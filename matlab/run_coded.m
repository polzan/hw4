close all; clear all; clc;

SNRs = linspace(0, 2.5, 100);
Nbits = 3e6;

for i=1:length(SNRs)
    if i == 1 || pbit_awgn_u(i-1) >= 1e-5
        pbit_awgn_u(i) = simulation_bound(Nbits, SNRs(i), 'coded');
    else
        pbit_awgn_u(i) = NaN;
    end
    if i == 1 || pbit_ofdm_u(i-1) >= 1e-5
        pbit_ofdm_u(i) = simulate_ofdm(Nbits, SNRs(i), 'coded');
    else
        pbit_ofdm_u(i) = NaN;
    end
    if i == 1 || pbit_dfe_u(i-1) >= 1e-5
        pbit_dfe_u(i) = simulate_dfe(Nbits, SNRs(i), 'coded');
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

save('pbits_coded.mat');

fprintf('Coded OK\n');
