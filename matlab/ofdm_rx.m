function [y, Ty, y_subch, T_dft, r_subch] = ofdm_rx(r, T_ofdm, M, Npx, gc, t0)
% r: received signal, T_ofdm: period of the received signal, M: num of
% subchannels, Npx: length of the cyclic prefix, gc: impulse response of
% the channel + lowpass filters (g_rcos * q_c * g_rcos), t0: when to start
% to demodulate (in multiples of T_ofdm)
%
% y: demodulated signal, Ty: period of the demodulated signal

% Periods
T_dft = T_ofdm * (Npx + M);
Ty = T_dft / M;

% Start to demodulate from t0
r = r(t0+1:length(r));

% Pad the input to multiples of M+Npx
over_len = mod(length(r), M+Npx);
if over_len ~= 0
    pad_len = M+Npx - over_len;
    r = [r; zeros(pad_len, 1)];
end

r_subch = reshape(r, M+Npx, []);
x_subch_cyclic = r_subch(Npx+1:M+Npx,:); % Drop the cyclic prefix
x_subch = fft(x_subch_cyclic, [], 1);

if size(gc, 2) ~= 1
    gc = transpose(gc);
end

% Periodically translate gc by t0
gc = [gc(t0+1:length(gc)); flip(gc(2:t0))];

Gc = fft(gc, M);
if any(abs(Gc) < 1e-2)
    warning('Gc is attenuating >=40dB');
end
y_subch = zeros(M, size(x_subch, 2));
for k=1:size(x_subch, 2)
    y_subch(:,k) = x_subch(:,k) ./ Gc;
end

y = reshape(y_subch, [], 1);
end
