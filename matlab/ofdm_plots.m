close all; clear all; clc;

p = global_parameters();

freq_resp_resolution = 1024;

% Fixed params
upsample_factor = 4;
rho_ofdm = 0.0625;

% Filters and responses
rcos_f = rcosdesign(rho_ofdm, p.ofdm.rcos_length/upsample_factor, upsample_factor, 'sqrt');
qc = channel_response(p.channel.qc_length);
rcos_qc = conv(rcos_f, qc);
all_resp = conv(rcos_qc, rcos_f); % at T_c
gc = downsample(all_resp, upsample_factor, mod(p.ofdm.t0, upsample_factor));

t0_sampled = floor(p.ofdm.t0/upsample_factor);

% qc(nTc)
figure;
stem(0:length(qc)-1, qc);
xlabel('n [@T_c]');
ylabel('q_c(nT_c)');
xlim([0, length(qc)-1]);
grid on;
print('qc', '-deps');

% g_rcos(nTc)
figure;
stem(0:length(rcos_f)-1, rcos_f);
xlabel('n [@T_c]');
ylabel('g_{rcos}(nT_c)');
grid on;
print('g_rcos', '-deps');

% g_c(nTc)
figure;
stem(0:length(all_resp)-1, all_resp);
xlabel('n [@T_c]');
ylabel('g_c(nT_c)');
xlim([20, 80]);
grid on;
print('gc', '-deps');

% h(mTofdm)
figure;
stem((0:length(gc)-1)-t0_sampled, gc);
xlabel('m [@T_{ofdm}]');
ylabel('h(mT_{ofdm})');
xlim([-2 15]);
grid on;
print('h', '-deps');

% Qc(f)
[Qc, f] = freqz(qc, 1, 'half', freq_resp_resolution, 1);
figure;
plot(f, 20*log10(abs(Qc)));
xlabel('f/T_c');
ylabel('|Q_c(f/T_c)| [dB]');
set(gca, 'XTick', 0:1/8:1/2);
grid on;
print('qc_freqz', '-deps');

% Grc(f)
[Grc, f] = freqz(rcos_f, 1, 'half', freq_resp_resolution, 1);
figure;
plot(f, 20*log10(abs(Grc)));
xlabel('f/T_c');
ylabel('|G_{rc}(f/T_c)| [dB]');
set(gca, 'XTick', 0:1/8:1/2);
ylim([-40 10]);
grid on;
print('g_rcos_freqz', '-deps');

% DFT of gc
Gc = fft(gc, p.ofdm.M);
figure;
plot(0:length(Gc)-1, 20*log10(abs(Gc)));
xlabel('i');
ylabel('|G_c(i)| [dB]');
xlim([0 p.ofdm.M-1]);
set(gca, 'XTick', [0:64:511, 511]);
grid on;
print('gc_dft', '-deps');
