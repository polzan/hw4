function [bits_out] = interlace(bits_in)
interlace = zeros(31,35);
int_size = numel(interlace);    %number interlaced bits
n_interlace = floor(length(bits_in)/int_size) +1;  %number of iterations
rem_bits = mod(length(bits_in),int_size);
int_seq = zeros(numel(interlace)*n_interlace,1);
l = 0;
while l < n_interlace -1        
    l = l+1;
    interlace(:) = bits_in((l-1)*int_size +1 : l*int_size); %write column-wise
    int_seq((l-1)*int_size + 1 : l*int_size,1) = reshape(interlace.',int_size,1);   %read row-wise
end
%copy remaining bits
interlace = zeros(31,35);
interlace(1:rem_bits) = bits_in(l*int_size +1 : length(bits_in)); 
int_seq(l*int_size + 1 : (l+1)*int_size,1) = reshape(interlace.',int_size,1);

% if mod(n_interlace,2)==1    % remove the last 0 bit to make QPSKmodulator working if int_seq is odd
%     int_seq = int_seq(1:length(int_seq)-1,1);     
% end
% 
if mod(n_interlace,2)==1        %if int_seq is odd i add onother block of size 1085
    int_seq = [int_seq; zeros(1085,1)]; %to make QPSKmodulator work and don't loose data;
end     %at the receiver we'll compare only info_bits
bits_out = int_seq;
end
