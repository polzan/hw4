function qc = channel_response(qc_length)
b = [zeros(1,10), 0.7424];   %beta
a = [1, -0.67];     %1-alfa
qc = impz(b, a, qc_length);
end
