function params = global_parameters()
params.sym_period = 1;

params.channel.qc_length = 20;

params.ofdm.M = 512;
params.ofdm.Npx = 12;
params.ofdm.Nvirt = 48;

params.ofdm.t0 = 27;
params.ofdm.rcos_length = 40;

params.dfe.M1 = 3;
params.dfe.M2 = 2;
params.dfe.D = 1;

params.dfe.t0 = 24;
end
