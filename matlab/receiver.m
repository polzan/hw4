function [dec_bits] = receiver(bits)

[est_bits, ~] = QPSKdemodulator(bits);

tmp = zeros(35,31);
deint_size = numel(tmp);    %number of  bits to be deinterlaced
n_deinterlace = floor(length(est_bits)/deint_size);  %number of iterations
deint_seq = zeros(deint_size*n_deinterlace,1);
for l = 1:n_deinterlace        
    tmp(:) = est_bits((l-1)*deint_size +1 : l*deint_size); %write column-wise
    deinterlace = tmp.';    %rotate to write row-wise
    deint_seq((l-1)*deint_size + 1 : l*deint_size,1) = reshape(deinterlace,deint_size,1);   %read column-wise
end

dec_bits = deint_seq;

end

