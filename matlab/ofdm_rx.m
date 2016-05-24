function [y, Ty] = ofdm_rx(r, T_ofdm, M, Npx)
% r: received signal, T_ofdm: period of the received signal, M: num of
% subchannels, Npx: length of the cyclic prefix
%
% y: demodulated signal, Ty: period of the demodulated signal

r_subch = reshape(r, M+Npx, []);
x = r_subch(Npx+1:M+Npx,:); % Drop the cyclic prefix
y_subch = fft(x, [], 2);
y = reshape(y_subch, [], 1);
T_ofdm_no_prefix = T_ofdm * M / (M+Npx);
Ty = T_ofdm_no_prefix * M;
end
