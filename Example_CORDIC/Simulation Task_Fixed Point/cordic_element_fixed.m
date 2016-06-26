function [x_k1, y_k1, z_k1, e_k ] = cordic_element_fixed( x_k, y_k, z_k, order, mode, bit_wide)
%Unit for CORDIC algorithm
%Input: x_k, y_k, z_k, referring the function
%       order: unit order
%       mode: CORDIC mode
%            sin/cos for 1; atan for 2; sqrt for 3;
%       bit_wide: ports bit wide
%            1 : QX.X
%            2 : x _ Q(3+X).x, y and z _ QX.X
%            3 : (7+X).X, and the integer part should be in [1, 100]
%Output: x_k1, y_k1, z_k1, referring the function
%        e_k: for Verilog implement
    
e_k = floor(atan(2^(-order)) * (2^bit_wide));

u = 1;

%d_k depends on mode
if (mode == 1)
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

%fixed operation
dx = u* d_k * y_k * ( 2^(-order));
dy = d_k * x_k * ( 2^(-order));
dz = d_k * e_k;

%tail operations
dx = sign(dx) * floor(abs(dx));
dy = sign(dy) * floor(abs(dy));
dz = sign(dz) * floor(abs(dz));

% dx = floor(dx);
% dy = floor(dy);
% dz = floor(dz);


x_k1 = x_k - dx;
y_k1 = y_k + dy;
z_k1 = z_k - dz;

%saturation operations
if ( mode == 1)
    if (x_k1 >= 2^bit_wide)
        x_k1 = 2^bit_wide - 1;
    elseif( -x_k1 >= 2^bit_wide)
        x_k1 = -(2^bit_wide - 1);
    end
    if (y_k1 >= 2^bit_wide)
        y_k1 = 2^bit_wide - 1;
    elseif( -x_k1 >= 2^bit_wide)
        y_k1 = -(2^bit_wide - 1);
    end
    if (z_k1 >= 2^bit_wide)
        z_k1 = 2^bit_wide - 1;
    elseif( -x_k1 >= 2^bit_wide)
        z_k1 = -(2^bit_wide - 1);
    end
elseif (mode == 2)
    if (x_k1 >= 2^(bit_wide+2))
        x_k1 = 2^(bit_wide+2) - 1;
    elseif( -x_k1 >= 2^(bit_wide+2))
        x_k1 = -(2^(bit_wide+2) - 1);
    end
    if (y_k1 >= 2^bit_wide)
        y_k1 = 2^bit_wide - 1;
    elseif( -x_k1 >= 2^bit_wide)
        y_k1 = -(2^bit_wide - 1);
    end
    if (z_k1 >= 2^bit_wide)
        z_k1 = 2^bit_wide - 1;
    elseif( -x_k1 >= 2^bit_wide)
        z_k1 = -(2^bit_wide - 1);
    end
else
    if (x_k1 >= 2^(bit_wide+7))
        x_k1 = 2^(bit_wide+7) - 1;
    elseif( -x_k1 >= 2^(bit_wide+7))
        x_k1 = -(2^(bit_wide+7) - 1);
    end
    if (y_k1 >= 2^(bit_wide+7))
        y_k1 = 2^(bit_wide+7) - 1;
    elseif( -x_k1 >= 2^(bit_wide+7))
        y_k1 = -(2^(bit_wide+7) - 1);
    end
    if (z_k1 >= 2^(bit_wide+7))
        z_k1 = 2^(bit_wide+7) - 1;
    elseif( -x_k1 >= 2^(bit_wide+7))
        z_k1 = -(2^(bit_wide+7) - 1);
    end
end
end