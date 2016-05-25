function g_rcos = rcos_filter(T_c, T_ofdm, rho_ofdm, filter_length)
if mod(filter_length, 2) == 0
    error('Give an odd filter length');
end
n = (-(filter_length-1)/2:(filter_length-1)/2);
t = n .* T_c;
g_rcos = sinc(t ./ T_ofdm) .* cos(pi*rho_ofdm*t ./ T_ofdm) ...
    ./ (1-(2*rho_ofdm*t./T_ofdm).^2);
end
