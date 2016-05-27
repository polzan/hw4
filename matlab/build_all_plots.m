close all; clear all; clc;

% Uncoded
SNRs = linspace(3, 14, 10);
Nbits = 5e5;

% QAM lower bound
Q = @(x) 1 - normcdf(x, 0, 1);
SNRs_lin = power(10, SNRs ./ 10);
pe_theor_bound = 2 .* Q(sqrt(SNRs_lin));
pbit_theor_bound = pe_theor_bound ./ 2;

for i=1:length(SNRs)
    pbit_awgn_u(i) = simulation_bound(Nbits, SNRs(i), 'coded');
    pbit_ofdm_u(i) = simulate_ofdm(Nbits, SNRs(i), 'uncoded');
end

figure;
semilogy(SNRs, pbit_theor_bound);
hold on;
semilogy(SNRs, pbit_awgn_u);
semilogy(SNRs, pbit_ofdm_u);
ylim([1e-5, 1e-1]);

% Coded
SNRs = linspace(1.5, 3.5, 5);
Nbits = 1e5;

for i=1:length(SNRs)
    pbit_awgn_c(i) = simulation_bound(Nbits, SNRs(i), 'coded');
    pbit_ofdm_c(i) = simulate_ofdm(Nbits, SNRs(i), 'coded');
end

figure;
semilogy(SNRs, pbit_awgn_c);
hold on;
semilogy(SNRs, pbit_ofdm_c);
ylim([1e-5, 1e-1]);
