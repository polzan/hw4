function [s, T_ofdm, a_subch, T_idft, A, A_tx] = ofdm_tx(a, T, M, Npx)
% a: symbols, T: symbol period, M: num of subchannels, Npx: length of the
% cyclic prefix
%
% s: modulated signal, T_ofdm: period of the modulated signal

% Periods
T_idft = M*T;
T_ofdm = T_idft / (M+Npx);

% Pad the input to multiples of M
over_len = mod(length(a), M);
if over_len ~= 0
    pad_len = M - over_len;
    a = [a; zeros(pad_len, 1)];
end

a_subch = reshape(a, M, []);
A = ifft(a_subch, [], 1);
prefix = A(M-Npx+1:M,:);
A_tx = [prefix; A];
s = reshape(A_tx, [], 1);
end
