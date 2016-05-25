close all; %clear all; clc;
Nbits = 2^16;
bits = round(rand(Nbits, 1));

a = QPSKmodulator(bits);
T = 1;

M = 512;
Npx = floor(35/4); % max possible?
[s, T_ofdm] = ofdm_tx(a, T, M, Npx);

SNR = 11;
t0 = 35; % 2 half-length of rcos + peak of qc
qc_length = 20;
rcos_length = 25;
[r, gc] = ofdm_channel(s, T_ofdm, SNR, t0, qc_length, rcos_length, M, Npx, 'shuffle');

t0_sampled = floor(t0/4);

[y, Ty] = ofdm_rx(r(t0_sampled-Npx+1:length(r)), T_ofdm, M, Npx, gc);


figure;
scatter(real(y), imag(y));
hold on;
scatter(real(a), imag(a), 'rx');

[bits_det, a_det] = QPSKdemodulator(y);

bits_cut = bits(1:length(bits_det));

err = sum(bits_cut ~= bits_det);
Pbit = err/length(bits_det)




figure;
stem((0:length(bits)-1), bits .* 0.9);
hold on;
stem((0:length(bits_det)-1) + t0_sampled, bits_det);