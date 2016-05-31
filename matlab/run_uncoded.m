close all; clear all; clc;

SNRs = linspace(3, 15, 50);
Nbits = 3e6;

for i=1:length(SNRs)
    if i == 1 || pbit_awgn_u(i-1) >= 1e-5
        pbit_awgn_u(i) = simulation_bound(Nbits, SNRs(i), 'uncoded');
    else
        pbit_awgn_u(i) = NaN;
    end
    if i == 1 || pbit_ofdm_u(i-1) >= 1e-5
        pbit_ofdm_u(i) = simulate_ofdm(Nbits, SNRs(i), 'uncoded');
    else
        pbit_ofdm_u(i) = NaN;
    end
    if i == 1 || pbit_dfe_u(i-1) >= 1e-5
        pbit_dfe_u(i) = simulate_dfe(Nbits, SNRs(i), 'uncoded');
    else
        pbit_dfe_u(i) = NaN;
    end
    
    if mod(i, 5) == 0
        fprintf('%d', i);
    else
        fprintf('.');
    end
end
fprintf('\n');

save('pbits_uncoded.mat');

fprintf('Uncoded OK\n');
