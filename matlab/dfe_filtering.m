function [detected_syms, y] = dfe_filtering(c, b, x, D)
% xff = conv(c, x);
% xff = xff(1:length(x)+D);
xff = filter(c, 1, x);
if isempty(b) || all(b == 0)
    error('not implemented');
%     y = xff;
%     [~, detected_syms] = receiver(y, );
else
    Nsym = length(x);
    detected_syms = zeros(Nsym, 1);
    y = zeros(Nsym, 1);
    for k=0:Nsym-1
        if k-D-length(b) >= 0
            a_D = detected_syms((k-D-length(b)+1:k-D)+1);
        elseif k-D >= 0
            a_D = [zeros(length(b)-k+D-1, 1); detected_syms((0:k-D)+1)];
        else
            a_D = zeros(length(b), 1);
        end
        xfb_k = transpose(b) * flip(a_D);
        if k+1 <= length(x)
            x_k = xff(k+1);
        else
            x_k = 0;
        end
        y(k+1) = x_k + xfb_k;
        alpha = angle(y(k+1));
        if alpha >= -pi/4 && alpha <= pi/4  %1,0
            detected_syms(k+1) = 1;
        elseif alpha >= pi/4 && alpha <= pi*3/4 %0,1
            detected_syms(k+1) = 1j;
        elseif alpha >= -pi*3/4 && alpha <= pi/4    %0,-1
            detected_syms(k+1) = -1j;
        else %-1,0
            detected_syms(k+1) = -1;
        end
    end
end
end
