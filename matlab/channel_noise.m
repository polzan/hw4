function [w, sigma2_w] = channel_noise(num_samples, SNR, rcos_qc, M, Npx, Nvirt)
% Energy of the filters before s_c
E_tx_ch = norm(rcos_qc)^2;

sigma2_a = 1; % assuming iid symbols
sigma2_s = sigma2_a * (M - Nvirt)/M^2;
sigma2_w = E_tx_ch * sigma2_s / 10^(SNR/10);

w = sqrt(sigma2_w/2) .* (randn(num_samples, 1) + 1j * randn(num_samples, 1));
end
