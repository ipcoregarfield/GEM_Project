function [value, real_value, err, mid_results, ek, x0] = cordic_fixed( w, mode, bit_wide, order)
%Fixed point function for CORDIC algorithm to calculate one certain angle
%Input: w: value for calculation
%       order: CORDIC order
%       mode: CORDIC mode
%            sin/cos for 1; atan for 2; sqrt for 3;
%       bit_wide: ports bit wide
%            1 : QX.X
%            2 : x _ Q(3+X).x, y and z _ QX.X
%            3 : (7+X).X, and the integer part should be in [1, 100]
%       value domain of w:
%            1: [0, pi/4]
%            2: [0, 1]
%            3: [1, 100]
%            saturation operation of over domain
%Output: value: calculation result
%        err: calculation error
%        real_value: real function value
%        mid_results: for Verilog verification
%        ek: for Verilog implement
%        x0: 1/K for Verilog coding and verification 
K = 1.646760258121;
ek=[];
%input value check
if (mode == 1)
    %[0, pi/ 4]
    if (w < 0)
        w1 = 0;
    elseif ( w > pi/4)
        w1 = pi/4;
    else 
        w1 = w;
    end
elseif(mode == 2)
    %[0, 1]
    if (w < 0)
        w1 = 0;
    elseif ( w > 1)
        w1 = 1;
    else
        w1 = w;
    end
else
    %[1, 100]
    if (w(1) < 1)
        w1 = 0;
    elseif ( w(1) > 100)
        w1 = 100;
    else
        w1 = w(1);
    end
    
    if (w(2) < 1)
        w2 = 0;
    elseif ( w(2) > 100)
        w2 = 100;
    else
        w2 = w(2);
    end
end

%real value and initial value
if (mode == 1)
    %result: x_k = cos(w) and y_k = sin(w)
    x_k = 1/K;
    y_k = 0;
    z_k = w1;
    x_n = cos(w1);
    y_n = sin(w1);
elseif(mode == 2)
    %result: z_k = atan(w)
    x_k = 1;
    y_k = w1;
    z_k = 0;
    x_n = K*sqrt(sum(w1.^2));
    z_n = atan(w1);
else
    %result: x_k = K*sqrt(w(1)^2 + w(2)^2)
    x_k = w1;
    y_k = w2;
    z_k = 0;
    x_n = K*sqrt(w1^2+w2^2);
    z_n = atan(w2/w1);
end

%fixed point
if (mode == 1)
    %result: x_k = cos(w) and y_k = sin(w)
    x_k = floor(x_k * (2^bit_wide));
    y_k = floor(y_k * (2^bit_wide));
    z_k = floor(z_k * (2^bit_wide));
elseif(mode == 2)
    %result: z_k = atan(w)
    x_k = floor(x_k * (2^bit_wide));
    y_k = floor(y_k * (2^bit_wide));
    z_k = floor(z_k * (2^bit_wide));
else
    %result: x_k = K*sqrt(w(1)^2 + w(2)^2)
    x_k = floor(x_k) * (2^bit_wide) + floor((x_k - floor(x_k))* (2^bit_wide));
    y_k = floor(y_k) * (2^bit_wide) + floor((y_k - floor(y_k))* (2^bit_wide));
    z_k = floor(z_k) * (2^bit_wide) + floor((z_k - floor(z_k))* (2^bit_wide));
end
x0 = x_k;

%fixed point middle results
f_x = [x_k];
f_y = [y_k];
f_z = [z_k];
mid_results.angle = z_k;

for order1 = 0: order
    [x_k, y_k, z_k, e_k] = cordic_element_fixed( x_k, y_k, z_k, order1, mode, bit_wide);
    
    %record
    f_x = [f_x, x_k];
    f_y = [f_y, y_k];
    f_z = [f_z, z_k];
    ek=[ek e_k];
    
    %error calculation
    if (mode == 1)
        %result: x_k = cos(w) and y_k = sin(w)
        err = max ( abs([x_k/(2^bit_wide) - x_n, y_k/(2^bit_wide) - y_n]));
    elseif (mode == 2)
        %result: x_k = K*sqrt(1 + w^2) and z_k = atan(w)
        err = abs([z_k/(2^bit_wide) - z_n]);
    else
        err = abs([x_k/(2^bit_wide) - x_n])/K;
    end
end


if (mode == 1)
    value = [x_k, y_k];
    real_value = [x_n, y_n];
elseif (mode == 2)
    value = z_k;
    real_value = z_n;
else
    value = x_k;
    real_value = x_n;
end

%for bit check in Verilog
mid_results.x = f_x;
mid_results.y = f_y;
mid_results.z = f_z;

end