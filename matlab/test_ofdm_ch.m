close all; %clear all; clc;
Nbits = 2^18;
[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, 'uncoded');
T = 1;

M = 512;
Npx = floor(35/4); % max possible?
[s, T_ofdm, a_subch] = ofdm_tx(a, T, M, Npx);

SNR = 11;
t0 = 35; % 2 half-length of rcos + peak of qc
qc_length = 20;
rcos_length = 25;
[r, gc] = ofdm_channel(s, T_ofdm, SNR, t0, qc_length, rcos_length, M, Npx, 'shuffle');

t0_sampled = floor(t0/4);

[y, Ty, y_subch] = ofdm_rx(r(t0_sampled-Npx+1:length(r)), T_ofdm, M, Npx, gc);

figure;
subplot(2,1,1);
hold on;
stem(y_subch(1,:));
stem(a_subch(1,:));
subplot(2,1,2);
hold on;
stem(y_subch(2,:));
stem(a_subch(2,:));

Pbits = zeros(M, 1);
for i=1:M
    [bits_det, a_det] = QPSKdemodulator(y_subch(i,:));
    [bits_subch] = QPSKdemodulator(a_subch(i,:));
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

[bits_det, a_det] = QPSKdemodulator(y);

bits_cut = bits(1:length(bits_det));

err = sum(bits_cut ~= bits_det);
Pbit = err/length(bits_det)




% figure;
% stem((0:length(bits)-1), bits .* 0.9);
% hold on;
% stem((0:length(bits_det)-1) + t0_sampled, bits_det);