function [s, T_ofdm] = ofdm_subch_tx(a_subch, T_subch, Npx)
% a_subch: symbols divided in subchannels (M by K), T_subch: symbol period of each
% channel, Npx: length of the cyclic prefix
%
% s: modulated signal, T_ofdm: period of the modulated signal

M = size(a_subch,1);

% Periods
T_ofdm = T_subch / (M+Npx);

A = ifft(a_subch, [], 1);
prefix = A(M-Npx+1:M,:);
A_tx = [prefix; A];
s = reshape(A_tx, [], 1);
end
