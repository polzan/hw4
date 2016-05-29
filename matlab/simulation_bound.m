function [Pbit, err_count] = simulation_bound(Nbits, SNR, coded)

[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, coded);

sigma2_a = 2;
SNR_lin = 10^(SNR/10);
sigma2_wc = sigma2_a / SNR_lin;
wc = sqrt(sigma2_wc/2) .* (randn(length(a), 1) + 1j.*(randn(length(a), 1)));
y = a + wc;

dec_bits = receiver(y, n_info_bits, sigma2_wc, coded);

err_count = sum(dec_bits ~= uncoded_bits);
Pbit = err_count / length(bits);
end
