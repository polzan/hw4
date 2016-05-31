function [r, gc, T_c, t0_sampled, sigma2_w] = ofdm_channel(s, T_ofdm, ...
    SNR, t0, ...
    qc_length, rcos_length, ...
    M, Npx, Nvirt)
% SNR in dB, t0 in multiples of T_c
%
% output r, gc sampled at T_ofdm

% Fixed params
upsample_factor = 4;
rho_ofdm = 0.0625;
T_c = T_ofdm / upsample_factor;

% Filters and responses
rcos_f = rcosdesign(rho_ofdm, rcos_length/upsample_factor, upsample_factor, 'sqrt');
qc = channel_response(qc_length);
rcos_qc = conv(rcos_f, qc);
all_resp = conv(rcos_qc, rcos_f); % at T_c
gc = downsample(all_resp, upsample_factor, mod(t0, upsample_factor));

% Transmitter + channel
s_up = upsample(s, upsample_factor);
s_c = conv(rcos_qc, s_up);

% Noise
E_tx_ch = norm(rcos_qc)^2; % Energy of the filters before s_c

sigma2_a = 2; % assuming iid symbols
sigma2_s = sigma2_a * (M-Nvirt) / M^2;
sigma2_sc = sigma2_s * E_tx_ch;
sigma2_w = sigma2_sc / 10^(SNR/10);

w_c = wgn(length(s_c), 1, sigma2_w, 'linear', 'complex');
rn = s_c + w_c;

% Receiver filter
rn_filt = conv(rcos_f, rn);

% Sampling
r = downsample(rn_filt(1:length(s_up)+t0), upsample_factor, mod(t0, upsample_factor));
t0_sampled = floor(t0/upsample_factor);
end
