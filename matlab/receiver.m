function [dec_bits] = receiver(y, real_data_length, sigma2_w, rx_type)
if nargin < 4
    rx_type = 'uncoded';
end

switch rx_type
    case 'uncoded'
        dec_bits_all = QPSKdemodulator(y);
        dec_bits = dec_bits_all(1:real_data_length);
    case 'coded'
        real_data_length = 2*real_data_length;
        [~, ~, llr_int] = QPSKdemodulator(y, sigma2_w);
        llr = deinterlace(llr_int, real_data_length);
        
        dec= comm.LDPCDecoder;
        blocklength = size(dec.ParityCheckMatrix, 2);
        iw_length = size(dec.ParityCheckMatrix, 1);
        if mod(length(llr), blocklength) ~= 0
            error('The received LLR must be a multiple of the blocklength');
        end
        
        dec_bits = zeros(length(llr)/2, 1);
        for i=0:length(llr)/blocklength-1
            block = llr(i*blocklength+1:(i+1)*blocklength);
            dec_bits_block = step(dec, block);
            dec_bits(i*iw_length + 1 : (i+1)*iw_length) = dec_bits_block;
        end
    otherwise
        error('specify coded or uncoded');
end
end

