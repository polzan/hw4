close all; %clear all; clc;
Nbits = 1e6;
coded = 'coded';

skip_final_transient = 100;
Nbits = Nbits + skip_final_transient;

[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, coded);
T = 1; % symbol period

M = 512;
Npx = 128; % length of gc - 1
Nvirt = 256;

% OFDM modulation
[s, T_ofdm, a_subch] = ofdm_tx(a, T, M, Npx, Nvirt);

% Channel
SNR = 2;
t0 = 27; % 2 half-length of rcos + peak of qc
qc_length = 20;
rcos_length = 40;
[r, gc, T_c, t0_sampled, sigma2_w] = ofdm_channel(s, T_ofdm, SNR, t0, qc_length, rcos_length, M, Npx, Nvirt);

figure;
stem((0:length(gc)-1), gc);
hold on;
plot(t0_sampled .* ones(2,1), ylim);

% OFDM demodulator
[y, Ty, y_subch] = ofdm_rx(r, T_ofdm, M, Npx, Nvirt, gc, t0_sampled);

% Decode symbols
sigma2_W = (M-Nvirt)*sigma2_w;
bits_det = receiver(y, n_info_bits, sigma2_W, coded);

% Check errors
err_count = sum(uncoded_bits(1:length(uncoded_bits)-skip_final_transient) ~= bits_det(1:length(bits_det)-skip_final_transient));
Pbit = err_count/(length(uncoded_bits)-skip_final_transient)

% figure;
% subplot(2,1,1);
% hold on;
% stem(real(y_subch(1,:)));
% stem(real(a_subch(1,:)));
% subplot(2,1,2);
% hold on;
% stem(real(y_subch(100,:)));
% stem(real(a_subch(100,:)));

Pbits = zeros(M-Nvirt, 1);
for i=1:M-Nvirt
    bits_det = receiver(y_subch(i,:), length(y_subch(i,:)), NaN, 'uncoded');
    [bits_subch] = receiver(a_subch(i,:), length(a_subch(i,:)), NaN, 'uncoded');
    errs = sum(bits_subch ~= bits_det);
    Pbits(i) = errs / length(bits_det);
end

figure;
bar(0:M-1-Nvirt, Pbits);
title('Pbit per subch');
