close all; clear all; clc;

SNRs = linspace(3, 14, 25);
Nbits = 3e6;

for i=1:length(SNRs)
    pbit_awgn_u(i) = simulation_bound(Nbits, SNRs(i), 'uncoded');
    pbit_ofdm_u(i) = simulate_ofdm(Nbits, SNRs(i), 'uncoded');
    pbit_dfe_u(i) = simulate_dfe(Nbits, SNRs(i), 'uncoded');
end

save('pbits_uncoded.mat');
