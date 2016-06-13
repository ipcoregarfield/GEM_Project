function [ bit_wide, value, real_value, err, mid_results, ek] = cordic_bitwide_fixed( w, mode, order, limited_err)
%Fixed point function for CORDIC algorithm to calculate one certain angle
%Input: w: value for calculation
%       order: CORDIC order
%       limited_err: maximum error asked
%       mode: CORDIC mode
%            sin/cos for 1; atan for 2; sqrt for 3;
%       value domain of w:
%            1: [0, pi/4]
%            2: [0, 1]
%            3: [1, 100]
%            saturation operation of over domain
%Output: value: calculation result
%        err: calculation error
%        real_value: real function value
%        bit_wide: ports bit wide
%            1 and 2 in format QX.X
%            3 in format 7.X, and the integer part should be in [1, 100],
%            TBD
%        results: for Verilog verification
%        ek: for Verilog implement

%Quantization considered
bit_wide = -floor(log2(limited_err));

err = 1e8;

%searching
while (err > limited_err)
    [value, real_value, err, mid_results, ek] = cordic_fixed( w, mode, bit_wide, order);
    
    bit_wide = bit_wide + 1;
    if (bit_wide == 1000)
        warning('Cannot find the value');
        break;
    end
end

bit_wide = bit_wide - 1;