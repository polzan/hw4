function [n_info_bits, symbols, bits, uncoded_bits] = transmitter(n_bits_target, tx_type)
%generates random sequences of lengths multiple of 32400
warning('off', 'comm:fec:DeprecatedFunction');
enc= fec.ldpcenc;
cw_length = 2*enc.NumInfoBits;   %codeword length
iw_length = enc.NumInfoBits;    %infoword length
n_blocks = ceil(n_bits_target/iw_length);
n_bits = n_blocks*cw_length; %tot. number of bits coded
n_info_bits = n_blocks*iw_length;   %tot. number of info-bits tx

if nargin < 2
    tx_type = 'uncoded';
end

switch tx_type
    case 'coded'
        sequence = zeros(1,n_bits);
        uncoded_bits = zeros(1, n_info_bits);
        for i = 1 : n_blocks
            msg= randi([0 1],1,enc.NumInfoBits);
            uncoded_bits((i-1)*enc.NumInfoBits+1:i*enc.NumInfoBits) = msg;
            codeword = encode(enc,msg);
            sequence(1,(i-1)*cw_length + 1 : i*cw_length) = codeword;
        end
        uncoded_bits = transpose(uncoded_bits);
        coded_bits = transpose(sequence);
        bits = interlace(coded_bits);
    case 'uncoded'
        uncoded_bits = randi([0 1],n_info_bits,1);
        bits = uncoded_bits;
    otherwise
        error('specify coded or uncoded');
end

modObj= modem.pskmod('M',4,'InputType','Bit');
symbols= modulate(modObj, bits);
end
