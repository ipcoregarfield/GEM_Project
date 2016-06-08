function [x_k1, y_k1, z_k1 ] = cordic_element_float( x_k, y_k, z_k, order, mode)
%Unit for CORDIC algorithm
%Input: x_k, y_k, z_k, referring the function
%       order: unit order
%       mode: CORDIC mode
%            mode(1): rotate mode
%                     triangle for 1; linear for 2; hyperbolic for 3;
%            mode(2): ending mode
%                     z to 0 for 1; y to 0 for 2
%Output: x_k1, y_k1, z_k1, referring the function
if (mode(1) == 1)
    e_k = atan(2^(-order));
elseif (mode(1) == 2)
    e_k = 2^(-order);
else
    if (order == 0)
        e_k = atanh(1-1e-15);
    else
        e_k = atanh(2^(-order));
    end
end

if (mode(1) == 1)
    u = 1;
elseif (mode(1) == 2)
    u = 0;
else
    u = -1;
end

%d_k depends on mode(2)
if (mode(2) == 1)
    D = z_k;
else
    D = -(x_k * y_k);
    if ( D  == 0)
        D = -1;
    end
end

if (D >= 0)
    d_k = 1;
else
    d_k = -1;
end

x_k1 = x_k - u*d_k * y_k * ( 2^(-order));
y_k1 = y_k + d_k * x_k * ( 2^(-order));
z_k1 = z_k - d_k * e_k;
end