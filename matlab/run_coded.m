close all; clear all; clc;

SNRs = linspace(0, 2.5, 25);
Nbits = 3e6;

for i=1:length(SNRs)
    pbit_awgn_c(i) = simulation_bound(Nbits, SNRs(i), 'coded');
    pbit_ofdm_c(i) = simulate_ofdm(Nbits, SNRs(i), 'coded');
    pbit_dfe_c(i) = simulate_dfe(Nbits, SNRs(i), 'coded');
    
    if mod(i, 5) == 0
        fprintf('%d', i);
    else
        fprintf('.');
    end
end
fprintf('\n');

save('pbits_coded.mat');

fprintf('Coded OK\n');
