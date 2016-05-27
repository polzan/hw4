close all; %clear all; clc;

M = 30; K = 10;
a_subch = ones(M, K) .* -1;

a_subch(10, :) = ones(1, K);
Npx = 4;
T = 1;
[s, T_ofdm] = ofdm_subch_tx(a_subch, T, Npx);

gc = [1, 0.6, -0.8, 0.4, 0.6];
r = filter(gc, 1, s);
t0 = 0;

[y_subch, T_subch] = ofdm_subch_rx(r, T_ofdm, M, Npx, gc, t0);

errs = zeros(M, 1);
for i=1:M
    errs(i) = sum(abs(real(y_subch(i,:)) - a_subch(i,:)) >= 0.5);
    
end

sum(errs)

figure;
stem(real(y_subch(10,:)));
hold on;
stem(a_subch(10,:));

figure;
stem(real(y_subch(15,:)));
hold on;
stem(a_subch(15,:));

figure;
scatter(real(y_subch(1,:)), imag(y_subch(1,:)));
hold on;
scatter(real(a_subch(1,:)), imag(a_subch(1,:)));

% figure;
% stem(0:length(s)-1, s);
% hold on;
% stem(0:length(r)-1, r);
