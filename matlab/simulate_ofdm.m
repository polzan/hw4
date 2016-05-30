function [Pbit, err_count] = simulate_ofdm(Nbits, SNR, coded)
p = global_parameters();

skip_final_transient = 100;
Nbits = Nbits + skip_final_transient;

[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, coded);
T = p.sym_period;

M = p.ofdm.M;
Npx = p.ofdm.Npx; % length of gc - 1
Nvirt = p.ofdm.Nvirt;

% OFDM modulation
[s, T_ofdm, a_subch] = ofdm_tx(a, T, M, Npx, Nvirt);

% Channel
t0 = p.ofdm.t0; % 2 half-length of rcos + peak of qc
qc_length = p.channel.qc_length;
rcos_length = p.ofdm.rcos_length;
[r, gc, T_c, t0_sampled, sigma2_w] = ofdm_channel(s, T_ofdm, SNR, t0, qc_length, rcos_length, M, Npx, Nvirt);

% OFDM demodulator
[y, Ty, y_subch] = ofdm_rx(r, T_ofdm, M, Npx, Nvirt, gc, t0_sampled);

% Decode symbols
sigma2_W = (M-Nvirt)*sigma2_w;
bits_det = receiver(y, n_info_bits, sigma2_W, coded);

% Check errors
err_count = sum(uncoded_bits(1:length(uncoded_bits)-skip_final_transient) ~= bits_det(1:length(bits_det)-skip_final_transient));
Pbit = err_count/(length(uncoded_bits)-skip_final_transient);
end
