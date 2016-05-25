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

interlace = zeros(31,35);
n_interlace = floor(length(sequence)/numel(interlace)) +1;  %number of iterations
int_size = numel(interlace);
rem_bits = mod(length(sequence),numel(interlace));
int_seq = zeros(numel(interlace)*n_interlace,1);
for l = 1:n_interlace -1        
    interlace(:) = sequence((l-1)*int_size +1 : l*int_size); %write column-wise
    int_seq((l-1)*int_size + 1 : l*int_size,1) = reshape(interlace.',int_size,1);   %read row-wise
end
%copy remaining bits
interlace = zeros(31,35);
interlace(1:rem_bits) = sequence(l*int_size +1 : length(sequence)); 
int_seq(l*int_size + 1 : (l+1)*int_size,1) = reshape(interlace.',int_size,1);

% if mod(n_interlace,2)==1    % remove the last 0 bit to make QPSKmodulator working if int_seq is odd
%     int_seq = int_seq(1:length(int_seq)-1,1);     
% end

if mod(n_interlace,2)==1        %if int_seq is odd i add onother block of size 1085
    int_seq = [int_seq; zeros(1085,1)]; %to make QPSKmodulator work and don't loose data;
end                                 %at the receiver we'll compare only info_bits

symbols = QPSKmodulator(int_seq);

end