close all; clear all; clc;

SNRs = linspace(0, 2, 10);
Nbits = 3e6;

for i=1:length(SNRs)
    pbit_awgn_c(i) = simulation_bound(Nbits, SNRs(i), 'coded');
    pbit_ofdm_c(i) = simulate_ofdm(Nbits, SNRs(i), 'coded');
    pbit_dfe_c(i) = simulate_dfe(Nbits, SNRs(i), 'coded');
end

save('pbits_coded.mat');
