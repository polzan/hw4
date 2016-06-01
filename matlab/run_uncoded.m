close all; clear all; clc;

SNRs = linspace(3, 15, 25);
Nbits = 3e6;

for i=1:length(SNRs)
    pbit_awgn_u(i) = simulation_bound(Nbits, SNRs(i), 'uncoded');
    pbit_ofdm_u(i) = simulate_ofdm(Nbits, SNRs(i), 'uncoded');
    pbit_dfe_u(i) = simulate_dfe(Nbits, SNRs(i), 'uncoded');
    
    if mod(i, 5) == 0
        fprintf('%d', i);
    else
        fprintf('.');
    end
end
fprintf('\n');

save('pbits_uncoded.mat');

fprintf('Uncoded OK\n');
