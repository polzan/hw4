close all;


t0 = 24;
M1 = 3;
M2 = 2;
D = 1;
SNR = Inf;
SNR_lin = 10^(SNR/10);

Nbits = 2^20;
[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, 'uncoded');

[rc, sc, qc, wc, sigma2_a, N0] = dfe_trasmitter(a, SNR, 25, t0);

[c, b] = build_dfe_filters(qc, flip(conj(qc)), t0, sigma2_a, N0, D, M1, M2);

rr_sampled = downsample(rc, 4, mod(t0,4));

[dec_sym_dfe, y] = dfe_filtering(c, b, rr_sampled, D);

qR_sampled = downsample(conv(qc,flip(conj(qc))),4,mod(t0,4));
% qR_sampled = downsample(qR, 4, mod(t0, 4));
% psi = conv(c, qR_sampled);
t0_sampled = floor(t0/4);
rr_syms_only = dec_sym_dfe(t0_sampled+D+1:length(dec_sym_dfe));
y = y(t0_sampled+D+1:length(y));

bits_det = receiver(y, n_info_bits, NaN, 'uncoded');

% [dec_bits, dec_syms] = QPSKdemodulator(rr_syms_only);
% 
% bits_notail = bits(1:length(dec_bits)); % bits transmitted without the final transient
err_count = sum(abs(bits_det(1:length(bits_det)-2))-uncoded_bits(3:length(uncoded_bits)));
Pbit = err_count / length(bits_det)
% fprintf('Pbit %f\n', Pbit);
