close all; %clear all; clc;
Nbits = 2^18;
[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, 'coded');
T = 1;

M = 512;
Npx = 17; % length of gc - 1
[s, T_ofdm, a_subch] = ofdm_tx(a, T, M, Npx);

SNR = 7.1;
sigma = sqrt(10^(-SNRdB/10));
t0 = 35; % 2 half-length of rcos + peak of qc
qc_length = 25;
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

figure;
scatter(real(y), imag(y));
hold on;
scatter(real(a), imag(a), 'rx');

bits_det = receiver(y, n_info_bits, sigma^2, 'coded');
%%%%to see what happens channel by channel%%%%%%%
% if mod(length(bits_det),M) ~= 0 
%    bits_subch = [bits_det; zeros(M-mod(length(bits_det),M),1)];
%    uncoded_subch = [uncoded_bits; zeros(M-mod(length(bits_det),M),1)];
% end
% bits_det_subch = reshape(bits_subch, M, []);
% unc_bits_subch = reshape(uncoded_subch, M, []);
% Pbits = abs((bits_det_subch-unc_bits_subch))*ones(length(unc_bits_subch(1,:)),1)./length(bits_det_subch(1,:));
% figure;
% plot(0:M-1, Pbits);
% title('Pbit per subch');

err = sum(uncoded_bits ~= bits_det);
Pbit = err/length(bits_det)



