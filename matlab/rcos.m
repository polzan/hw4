function y = rcos(x, rho)
if size(x,2) ~= 1
    x = transpose(x);
end
if size(x,2) ~= 1
    error('x is not a vector');
end

y = zeros(length(x), 1);

one_mask = abs(x) <= (1-rho)/2;
y(one_mask) = ones(sum(one_mask), 1);

cos_mask = and((1-rho)/2 < abs(x),  abs(x) <= (1+rho)/2);
y(cos_mask) = cos(pi/(2*rho) * (abs(x(cos_mask)) - (1-rho)/2)).^2;
end
