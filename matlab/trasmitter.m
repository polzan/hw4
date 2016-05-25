function [n_info_bits, symbols] = trasmitter(n_bits_target, tx_type)
%generates random sequences of lengths multiple of 32400
enc= fec.ldpcenc;
cw_length = 2*enc.NumInfoBits;   %codeword length
iw_length = enc.NumInfoBits;    %infoword length
n_blocks = ceil(n_bits_target/iw_length);
n_bits = n_blocks*cw_length; %tot. number of bits coded
n_info_bits = n_blocks*iw_length;   %tot. number of info-bits tx

if nargin > 1    %coded
    sequence = zeros(1,n_bits);
    for i = 1 : n_blocks
        msg= randi([0 1],1,enc.NumInfoBits);
        codeword = encode(enc,msg);
        sequence(1,(i-1)*cw_length + 1 : i*cw_length) = codeword;
    end
else        %uncoded
    sequence = randi([0 1],1,n_info_bits);
end

symbols = QPSKmodulator(sequence);

end