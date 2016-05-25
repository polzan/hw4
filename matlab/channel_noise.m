function [w, sigma2_w] = channel_noise(num_samples, SNR, rcos_qc, M, Npx, noise_seed)
% Energy of the filters before s_c
E_tx_ch = norm(rcos_qc)^2;

sigma2_a = 2; % <- what if the bits are channel coded?
sigma2_s = sigma2_a/M;
sigma2_w = E_tx_ch * sigma2_s / 10^(SNR/10);

oldstate = rng(noise_seed);
w = sqrt(sigma2_w) .* (randn(num_samples, 1) + 1j * randn(num_samples, 1));
rng(oldstate);
end
