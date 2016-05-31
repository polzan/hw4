function [rc, sc, qc, wc, sigma2_a, sigma2_wc, N0, gm] = dfe_trasmitter(a, T, SNR, qc_length,t0)
up_factor = 4;
T_Q = T/up_factor;

a_up = upsample(a,up_factor);
qc = channel_response(qc_length);
gm = flip(conj(qc));    %match filter
gc = conv(qc,gm);   %tot impulse resp.

E_qc = norm(qc)^2; 
sigma2_a = 2;
sigma2_wc = (E_qc * sigma2_a) / 10^(SNR/10);
N0 = sigma2_wc * T_Q;

sc = filter(qc,1, a_up);
wc = sqrt(sigma2_wc/2).*(randn(length(sc), 1) + 1j*(randn(length(sc), 1)));
rc = sc + wc;
% rc = rc(1:length(a_up)+t0);

end

