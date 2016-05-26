function [Pbit, err_count] = simulation_bound(Nbits, SNR, coded)
[num_bits, tx_syms, tx_bits, uncoded_bits] = transmitter(Nbits, coded);

sigma = sqrt(10^(-SNR/10));
rc_syms = awgn(tx_syms, SNR, 0);

detected = receiver(rc_syms, length(uncoded_bits), sigma^2, coded);

err_count = sum(uncoded_bits ~= detected);
Pbit = err_count / length(detected);
end
