close all; clear all;


t0 = 24;
t0_sampled = floor(t0/4);
M1 = 3;
M2 = 2;
D = 1;
SNRdB = 2.45;
SNR_lin = 10^(SNRdB/10);

Nbits = 2^18;
[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, 'coded');

[rc, sc, qc, wc, sigma2_a, sigma2_w, N0] = dfe_trasmitter(a, SNRdB, 25, t0);

[c, b] = build_dfe_filters(qc, flip(conj(qc)), t0, sigma2_a, N0, D, M1, M2);

rr = filter(flip(conj(qc)),1,rc);
rr_sampled = downsample(rr, 4, mod(t0,4));

[dec_sym_dfe, y] = dfe_filtering(c, b, rr_sampled, D);

% rr_syms_only = dec_sym_dfe(t0_sampled+D+1:length(dec_sym_dfe));
y = y(1 + t0_sampled + D : length(y));
y = [y; zeros(t0_sampled+D, 1)];        %pad the end to be decoded

bits_det = receiver(y, n_info_bits, sigma2_w, 'coded');

compared = length(bits_det) -D -t0_sampled -1;
err_count = sum(bits_det(1:compared) ~= uncoded_bits(1:compared));
Pbit = err_count / length(bits_det)
% fprintf('Pbit %f\n', Pbit);

figure;
subplot(2,1,1)
stem(uncoded_bits(1:50));
subplot(2,1,2)
stem(bits_det(1:50));

figure;
stem(bits_det-uncoded_bits(1:length(bits_det)));