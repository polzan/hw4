function [bits, detected_syms] = QPSKdemodulator(y)
bits = zeros(2*length(y),1);
detected_syms = zeros(length(y), 1);
d = 1;
for k=0:length(y)-1
    re = real(y(k+1));
    im = imag(y(k+1));
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
