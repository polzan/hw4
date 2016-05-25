function [dec_bits] = receiver(y, real_data_length, sigma2_w, rx_type)
if nargin < 4
    rx_type = 'uncoded';
end

switch rx_type
    case 'uncoded'
        demodObj = modem.pskdemod('OutputType', 'Bit', 'M', 4, 'DecisionType','Hard decision', 'NoiseVariance',sigma2_w);
        dec_bits_all = demodulate(demodObj, y);
        dec_bits = dec_bits_all(1:real_data_length);
    case 'coded'
        demodObj = modem.pskdemod('OutputType', 'Bit', 'M', 4, 'DecisionType','LLR', 'NoiseVariance',sigma2_w);
        llr_int = demodulate(demodObj, y);
        llr = deinterlace(llr_int, real_data_length);
        
        warning('off', 'comm:fec:DeprecatedFunction');
        dec= fec.ldpcdec;
        dec.DecisionType= 'Hard decision';
        dec.OutputFormat = 'Information part';
        dec.NumIterations= 50;
        dec.DoParityChecks= 'Yes';
        
        if mod(length(llr), dec.BlockLength) ~= 0
            error('The received LLR must be a multiple of the blocklength');
        end
        
        dec_bits = zeros(length(llr)/2, 1);
        for i=0:length(llr)/dec.BlockLength-1
            block = llr(i*dec.BlockLength+1:(i+1)*dec.BlockLength);
            dec_bits_block = decode(dec, transpose(block));
            dec_bits(i*dec.NumInfoBits + 1 : (i+1)*dec.NumInfoBits) = transpose(dec_bits_block);
        end
    otherwise
        error('specify coded or uncoded');
end
end

