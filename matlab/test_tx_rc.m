clear all; close all; clc;

[num_bits, tx_syms, tx_bits] = trasmitter(321098);
detected = receiver(tx_syms);

stem(detected(1:num_bits)-tx_bits)