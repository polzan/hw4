function [y, Ty, y_subch, T_subch] = ofdm_rx(r, T_ofdm, M, Npx, Nvirt, gc, t0)
% r: received signal, T_ofdm: period of the received signal, M: num of
% subchannels, Npx: length of the cyclic prefix, Nvirt: number of virtual subchans,
% gc: impulse response of
% the channel + lowpass filters (g_rcos * q_c * g_rcos), t0: when to start
% to demodulate (in multiples of T_ofdm)
%
% y: demodulated signal, Ty: period of the demodulated signal, y_subch:
% subchannels of y, T_dft: period of the DFT

[y_subch, T_subch] = ofdm_subch_rx(r, T_ofdm, M, Npx, gc, t0);

usable_chans = M - Nvirt;

% Periods
Ty = T_subch / M; % <- ???

% Remove the virtual subchannels
y_subch_novirt = [y_subch(1:floor(usable_chans/2),:); ...
    y_subch(floor(usable_chans/2) + Nvirt + 1:M,:)];

y = reshape(y_subch_novirt, [], 1);
end

