function [r, gc, T_c, sigma2_w] = ofdm_channel(s, T_ofdm, ...
    SNR, t0, ...
    qc_length, rcos_length, ...
    M, Npx, ...
    noise_seed)
% SNR in dB, t0 in multiples of T_c
%
% output r, gc sampled at T_ofdm

% Fixed params
upsample_factor = 4;
rho_ofdm = 0.0625;
T_c = T_ofdm / upsample_factor;

% Filters and responses
rcos_f = rcos_filter(T_c, T_ofdm, rho_ofdm, rcos_length);
qc = channel_response(qc_length);
rcos_qc = conv(rcos_f, qc);
all_resp = conv(rcos_qc, rcos_f); % at T_c
gc = downsample(all_resp, upsample_factor, mod(t0, upsample_factor));

% Transmitter + channel
s_up = upsample(s, upsample_factor);
s_c = filter(rcos_qc, 1, s_up);

% Noise
[w_c, sigma2_w] = channel_noise(length(s_c), SNR, rcos_qc, M, Npx, noise_seed);
rn = s_c + w_c;

% Receiver filter
rn_filt = filter(rcos_f, 1, rn);

% Sampling
r = downsample(rn_filt, upsample_factor, mod(t0, upsample_factor));
end
