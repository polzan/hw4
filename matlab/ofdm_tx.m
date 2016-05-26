function [s, T_ofdm, a_subch, A_tx] = ofdm_tx(a, T, M, Npx)
% a: symbols, T: symbol period, M: num of subchannels, Npx: length of the
% cyclic prefix
%
% s: modulated signal, T_ofdm: period of the modulated signal

% Pad the input to multiples of M
over_len = mod(length(a), M);
if over_len ~= 0
    pad_len = M - over_len;
    a = [a; zeros(pad_len, 1)];
end

a_subch = reshape(a, M, []);
%assert(all(a_subch(1,:).' == downsample(a, M, 0)));
A = ifft(a_subch, [], 1);
%assert(all(abs(A(1,:).' - ifft(downsample(a, M, 0))) < 1e-12));
prefix = A(M-Npx+1:M,:);
A_tx = [prefix; A];
s = reshape(A_tx, [], 1);
T_ofdm_no_prefix = T / M;
T_ofdm = (M + Npx) / M * T_ofdm_no_prefix;
%assert(all(s(Npx+1:M+Npx) == A(:,1)));
end
