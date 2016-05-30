function [Pbit,err_count] = simulate_dfe(Nbits, SNRdB, coded)
% Parameters
p = global_parameters();
t0 = p.dfe.t0;
t0_sampled = floor(t0/4);
M1 = p.dfe.M1;
M2 = p.dfe.M2;
D = p.dfe.D;

[n_info_bits, a, bits, uncoded_bits] = transmitter(Nbits, coded);

[rc, sc, qc, wc, sigma2_a, sigma2_w, N0] = dfe_trasmitter(a, p.sym_period, SNRdB, p.channel.qc_length, t0);

[c, b] = build_dfe_filters(qc, flip(conj(qc)), t0, sigma2_a, N0, D, M1, M2);

rr = filter(flip(conj(qc)),1,rc);
rr_sampled = downsample(rr, 4, mod(t0,4));

[dec_sym_dfe, y] = dfe_filtering(c, b, rr_sampled, D);

% rr_syms_only = dec_sym_dfe(t0_sampled+D+1:length(dec_sym_dfe));
y = y(1 + t0_sampled + D:length(y));   %cut transient
y = [y; zeros(t0_sampled + D, 1)];        %pad the end to be decoded

bits_det = receiver(y, n_info_bits, sigma2_w, coded);

compared = length(bits_det) -D -t0_sampled -1;
err_count = sum(bits_det(1:compared) ~= uncoded_bits(1:compared));
Pbit = err_count / length(bits_det);

% a_notail = a(1:Nbits/2);
% sym_err_count = sum(dec_syms ~= a_notail);
% Pe = sym_err_count / length(a_notail);

% bits_notail = bits(1:Nbits); % bits transmitted without the final transient
% err_count = sum(abs(dec_bits-bits_notail));
% Pbit = err_count / length(bits_notail);
end
