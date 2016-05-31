close all; clear all; clc;

load('pbits_uncoded');

figure;
semilogy(SNRs, pbit_awgn_u, 'k');
hold on;
semilogy(SNRs, pbit_ofdm_u, 'r');
semilogy(SNRs, pbit_dfe_u, 'b');
ylim([1e-5, 1e-1]);
xlim([3 15]);
grid on;
xlabel('SNR [dB]');
ylabel('Pbit');
legend('AWGN', 'OFDM', 'DFE');
set(gca, 'YTick', power(10, -5:-1));
set(gca, 'XTick', 3:2:15);
print('pbits_uncoded', '-depsc');

load('pbits_coded');

pbit_awgn_c = max(pbit_awgn_c, 5e-6);
pbit_ofdm_c = max(pbit_ofdm_c, 5e-6);
pbit_dfe_c = max(pbit_dfe_c, 5e-6);

figure;
semilogy(SNRs, pbit_awgn_c, 'k');
hold on;
semilogy(SNRs, pbit_ofdm_c, 'r');
semilogy(SNRs, pbit_dfe_c, 'b');
ylim([1e-5, 1e-1]);
%xlim([0 2]);
grid on;
xlabel('SNR [dB]');
ylabel('Pbit');
legend('AWGN', 'OFDM', 'DFE');
set(gca, 'YTick', power(10, -5:-1));
%set(gca, 'XTick', 3:2:15);
print('pbits_coded', '-depsc');
