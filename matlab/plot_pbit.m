close all; clear all; clc;

load('pbits_uncoded');

figure;
semilogy(SNRs, pbit_awgn_u);
hold on;
semilogy(SNRs, pbit_ofdm_u);
semilogy(SNRs, pbit_dfe_u);
ylim([1e-5, 1e-1]);

load('pbits_coded');

figure;
semilogy(SNRs, pbit_awgn_c);
hold on;
semilogy(SNRs, pbit_ofdm_c);
semilogy(SNRs, pbit_dfe_c);
ylim([1e-5, 1e-1]);
