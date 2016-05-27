function [s, T_ofdm, a_subch, T_subch, usable_chans] = ofdm_tx(a, T, M, Npx, Nvirt)
% a: symbols, T: symbol period, M: num of subchannels, Npx: length of the
% cyclic prefix, Nvirt: virtual subchannels
%
% s: modulated signal, T_ofdm: period of the modulated signal, a_subch:
% input subchannels (padded), T_idft: period of the IDFT block,
% usable_chans: subchannels that can carry symbols

usable_chans = M - Nvirt;
T_subch = M*T; % <- After the zeros ???

% Pad the input to multiples of the usable chans
over_len = mod(length(a), usable_chans);
if over_len ~= 0
    pad_len = usable_chans - over_len;
    a = [a; zeros(pad_len, 1)];
end

a_subch = reshape(a, usable_chans, []);

% Insert the virtual channels
a_virtual = [a_subch(1:floor(usable_chans/2),:); ...
    zeros(Nvirt,size(a_subch, 2)); ...
    a_subch(floor(usable_chans/2)+1:usable_chans,:)];

[s, T_ofdm] = ofdm_subch_tx(a_virtual, T_subch, Npx);
end
