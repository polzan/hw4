clear all; close all; clc;

[num_bits, tx_syms, tx_bits, uncoded_bits] = transmitter(1e5, 'coded');

SNRdB=  2.5; sigma = sqrt(10^(-SNRdB/10));
rc_syms = awgn(tx_syms, SNRdB, 0);

detected = receiver(rc_syms, length(uncoded_bits)*2, sigma^2, 'coded');

sum(uncoded_bits ~= detected)
