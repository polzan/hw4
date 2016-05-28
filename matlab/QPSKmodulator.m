function a = QPSKmodulator(bits)
if mod(length(bits), 2) ~= 0
    error('The QPSK modulator needs an even number of bits');
end
a = zeros(length(bits)/2, 1);
d = 1;
for k=0:length(a)-1
    if bits(2*k+1)
        sym = d;
    else
        sym = -d;
    end
    if bits(2*k+2)
        sym = sym + d*1j;
    else
        sym = sym - d*1j;
    end
    a(k+1) = sym;
end
end
