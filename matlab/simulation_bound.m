function [Pbit, err_count] = simulation_bound(Nbits, SNR, coded)

bits = round(rand(Nbits, 1));
a = QPSKmodulator(bits);

sigma2_a = 2;
SNR_lin = 10^(SNR/10);
sigma2_wc = sigma2_a / SNR_lin;
wc = sqrt(sigma2_wc/2) .* (randn(length(a), 1) + 1j.*(randn(length(a), 1)));
y = a + wc;

dec_bits = QPSKdemodulator(y);

err_count = sum(abs(dec_bits-bits));
Pbit = err_count / length(bits);
end
