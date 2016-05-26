close all; %clear all; clc;
Nbits = 2^18;
[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, 'uncoded');
T = 1;

M = 512;
Npx = 0; % length of gc - 1
[s, T_ofdm, a_subch] = ofdm_tx(a, T, M, Npx);

SNR = 22;
t0 = 35; % 2 half-length of rcos + peak of qc
qc_length = 20;
rcos_length = 25;
[r, gc, T_c, sigma2_w] = ofdm_channel(s, T_ofdm, SNR, t0, qc_length, rcos_length, M, Npx, 'shuffle');

t0_sampled = floor(t0/4);

figure;
stem((0:length(gc)-1), gc);
hold on;
plot(t0_sampled .* ones(2,1), ylim);

[y, Ty, y_subch] = ofdm_rx(r, T_ofdm, M, Npx, gc, t0_sampled);

figure;
subplot(2,1,1);
hold on;
stem(real(y_subch(1,:)));
stem(real(a_subch(1,:)));
subplot(2,1,2);
hold on;
stem(real(y_subch(2,:)));
stem(real(a_subch(2,:)));

Pbits = zeros(M, 1);
for i=1:M
    bits_det = receiver(y_subch(i,:), length(y_subch(i,:)), NaN, 'uncoded');
    [bits_subch] = receiver(a_subch(i,:), length(a_subch(i,:)), NaN, 'uncoded');
    errs = sum(bits_subch ~= bits_det);
    Pbits(i) = errs / length(bits_det);
end

figure;
plot(0:M-1, Pbits);
title('Pbit per subch');

figure;
scatter(real(y), imag(y));
hold on;
scatter(real(a), imag(a), 'rx');

bits_det = receiver(y, n_info_bits);

%bits_cut = bits(1:length(bits_det));

err = sum(bits ~= bits_det);
Pbit = err/length(bits_det)




% figure;
% stem((0:length(bits)-1), bits .* 0.9);
% hold on;
% stem((0:length(bits_det)-1) + t0_sampled, bits_det);