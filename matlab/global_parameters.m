function params = global_parameters()
params.sym_period = 1;

params.channel.qc_length = 20;

params.ofdm.M = 512;
params.ofdm.Npx = 24;
params.ofdm.Nvirt = 91;

params.ofdm.t0 = 51;
params.ofdm.rcos_length = 40;
end
