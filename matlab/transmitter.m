function [n_info_bits, symbols, bits, uncoded_bits] = transmitter(n_bits_target, tx_type)
%generates random sequences of lengths multiple of 32400
enc= comm.LDPCEncoder;
cw_length = size(enc.ParityCheckMatrix, 2);   %codeword length
iw_length = size(enc.ParityCheckMatrix, 1);    %infoword length
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
            msg= randi([0 1],1,iw_length);
            uncoded_bits((i-1)*iw_length+1:i*iw_length) = msg;
            codeword = transpose(step(enc,msg.'));
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
symbols = QPSKmodulator(bits);
end
