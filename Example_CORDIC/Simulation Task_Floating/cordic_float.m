function [value, real_value, err, order] = cordic_float( w, err_limitation,mode)
%Floating function for CORDIC algorithm to calculate one certain angle
%Input: w: value for calculation
%       err_limitation: allowed maximum error
%       mode: CORDIC mode
%            mode(1): corate mode
%                     trianle for 1; linear for 2; hyperbolic for 3;
%            mode(2): ending mode
%                     z to 0 for 1; y to 0 for 2
%Output: value: calculation result
%        order: CORDIC order to reach the error limitation
%        err: calculation error
%        real_value: real function value
if (mode(1) == 1)
    K = 1.646760258121;
else
    K = 0.8281593609602;
end

if (mode(1) == 1)
    if (mode(2) == 1)
        %result: x_k = cos(w) and y_k = sin(w)
        x_k = 1/K;
        y_k = 0;
        z_k = w;
        x_n = cos(w);
        y_n = sin(w);
    else
        %result: x_k = K*sqrt(1 + w^2) and z_k = atan(w)
        x_k = 1;
        y_k = w;
        z_k = 0;
        x_n = K*sqrt(1+w^2);
        z_n = atan(w);
    end
elseif (mode(1) == 2)
    %result: w(1) = a, w(2) = b, w(3) = c
    if (mode(2) == 1)
        % x_k = a and y_k = c+a*b
        x_k = w(1);
        y_k = w(3);
        z_k = w(2);
        x_n = w(1);
        y_n = w(3) + w(1)*w(2);
    else
        %x_k = a and z_k = c+b/a
        x_k = w(1);
        y_k = w(2);
        z_k = w(3);
        x_n = w(1);
        z_n = w(3) + w(2)/w(1);
    end
else
    if (mode(2) == 1)
        %result: x_k = cosh(w) and y_k = sinh(w)
        x_k = 1/K;
        y_k = 0;
        z_k = w;
        x_n = cosh(w);
        y_n = sinh(w);
    else
        %result: x_k = K*sqrt(1 - w^2) and z_k = atanh(w)
        x_k = 1;
        y_k = w;
        z_k = 0;
        x_n = K * sqrt(1 - w^2);
        z_n = atanh(w);
    end
end

if (mode(1) == 1)
    if (mode(2) == 1)
        %result: x_k = cos(w) and y_k = sin(w)
        err = max ( abs([x_k - x_n, y_k - y_n]));
    else
        %result: x_k = K*sqrt(1 + w^2) and z_k = atan(w)
        err = max ( abs([x_k - x_n, z_k - z_n]));
    end
elseif (mode(1) == 2)
    %result: w(1) = a, w(2) = b, w(3) = c
    if (mode(2) == 1)
        %x_k = a and y_k = c+a*b
        err = abs(y_k - y_n);
    else
        %x_k = a and z_k = c+b/a
        err = abs(z_k - z_n);
    end
else
    if (mode(2) == 1)
        %result: x_k = cosh(w) and y_k = sinh(w)
        err = max ( abs([x_k - x_n, y_k - y_n]));
    else
        %result: x_k = K*sqrt(1 - w^2) and z_k = atanh(w)
        err = abs(z_k -z_n);
    end
end

if (mode(1) == 3)
    order = 1;
else
    order = 0;
end

while ((err > err_limitation) && (order < 1000))
    [x_k, y_k, z_k] = cordic_element_float( x_k, y_k, z_k, order, mode);
    order = order +1;
    if (mode(1) == 1)
        if (mode(2) == 1)
            %result: x_k = cos(w) and y_k = sin(w)
            err = max ( abs([x_k - x_n, y_k - y_n]));
        else
            %result: x_k = K*sqrt(1 + w^2) and z_k = atan(w)
            err = max ( abs([x_k - x_n, z_k - z_n]));
        end
    elseif (mode(1) == 2)
        %result: w(1) = a, w(2) = b, w(3) = c
        if (mode(2) == 1)
            %x_k = a and y_k = c+a*b
            err = abs(y_k - y_n);
        else
            %x_k = a and z_k = c+b/a
            err = abs(z_k - z_n);
        end
    else
        if (mode(2) == 1)
            %result: x_k = cosh(w) and y_k = sinh(w)
            err = max ( abs([x_k - x_n, y_k - y_n]));
        else
            %result: x_k = K*sqrt(1 - w^2) and z_k = atanh(w)
            err = abs(z_k -z_n);
        end
    end
end
order = order - 1;


if (mode(2) == 1)
    value = [x_k, y_k];
    real_value = [x_n, y_n];
else
    value = [x_k, z_k];
    real_value = [x_n, z_n];
end

end