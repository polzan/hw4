function [y, Ty] = ofdm_rx(r, T_ofdm, M, Npx, gc)
% r: received signal, T_ofdm: period of the received signal, M: num of
% subchannels, Npx: length of the cyclic prefix, gc: impulse response of
% the channel + lowpass filters (g_rcos * q_c * g_rcos)
%
% y: demodulated signal, Ty: period of the demodulated signal

r_subch = reshape(r, M+Npx, []);
x_subch_cyclic = r_subch(Npx+1:M+Npx,:); % Drop the cyclic prefix
x_subch = fft(x_subch_cyclic, [], 1);

Gc = fft(gc, M);
if any(abs(Gc) < 1e-2)
    warning('Gc is very small');
end
y_subch = zeros(M, size(x_subch, 2));
for k=1:size(x_subch, 2)
    y_subch(:,k) = x_subch(:,k) ./ Gc;
end

y = reshape(y_subch, [], 1);
T_ofdm_no_prefix = T_ofdm * M / (M+Npx);
Ty = T_ofdm_no_prefix * M;
end
