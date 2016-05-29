function [bits, detected_syms, llr] = QPSKdemodulator(y, sigma2_w)
if nargin < 2
    sigma2_w = NaN;
end
real_y = real(y);
imag_y = imag(y);

llr = zeros(2*length(y),1);
llr((0:2:length(llr)-1)+1) = -2.*real_y ./ (sigma2_w/2);
llr((1:2:length(llr)-1)+1) = -2.*imag_y ./ (sigma2_w/2);

bits = zeros(2*length(y),1);
detected_syms = zeros(length(y), 1);
d = 1;
for k=0:length(y)-1
    re = real_y(k+1);
    im = imag_y(k+1);
    if re > 0
        sym = d;
        bits(2*k+1) = 1;
    else
        sym = -d;
        bits(2*k+1) = 0;
    end
    if im > 0
        sym = sym + d*1j;
        bits(2*k+2) = 1;
    else
        sym = sym - d*1j;
        bits(2*k+2) = 0;
    end
    detected_syms(k+1) = sym;
end
end
