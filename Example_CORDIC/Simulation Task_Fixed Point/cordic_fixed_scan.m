function [bit_wide, max_err, results, ek, errs, special_value] = cordic_fixed_scan( step, order, err_limitation, mode, bit_limitation)
%Whole angle scan for CORDIC algorithm
%Input: step: #step in the value domain
%       order: CORDIC order
%       err_limitation: allowed maximum error
%       bit_limitation: allowed maximum bit wide
%       mode: CORDIC mode
%            sin/cos for 1; atan for 2; sqrt for 3;
%Output: max_err: maximum error
%        order: CORDIC order to reach the error limitation
%        results: for Verilog verification
%        ek: for Verilog implement
%        errs, recorded error
%        special_value: those who cannot reach error limitation

%value domain
if (mode == 1)
    %value domain :[0, pi/4], considering the symmetry
    domain = 0:pi/4/(step-1):pi/4;
elseif (mode == 2)
    %value domain :[0, 1], considering the symmetry
    domain = 0:1/(step-1):1;
else
    %value domain :[0, 10], considering the symmetry
    domain = 0 :10/(step-1):10;
end

%bit wide search
max_bit = 0;
results.w =[];
results.x =[];
special_value =[];
errs = [];
if (mode ~= 3)
    %single scan value
    for loop1 = 1:step
        w = domain(loop1);
        [ bit_wide, value, real_value, err, mid_results, ek] = cordic_bitwide_fixed( w, mode, order,  err_limitation);
        if (bit_wide <= bit_limitation)
            if ( bit_wide > max_bit)
                max_bit = bit_wide;
            end
        else
            warning('Cannot reach the limitaion');
            special_value= [ special_value; [w, value]];
        end
    end
else
    %two scan values
    for loop1 = 1:step
        for loop2 = 1:step
            w = [domain(loop1); domain(loop2)];
            [bit_wide, value, real_value, err, mid_results, ek] = cordic_bitwide_fixed( w, mode, order,  err_limitation);
            if (bit_wide <= bit_limitation)
                if ( bit_wide > max_bit)
                    max_bit = bit_wide;
                end
            else
                warning('Cannot reach the limitaion');
                special_value= [ special_value; [w, value]];
            end
        end
    end
end
bit_wide = max_bit;

%errors calculation
max_err = 0;
if (mode(1) ~= 3)
    %single scan value
    for loop1 = 1:step
        w = domain(loop1);
        [value, real_value, err, mid_results, ek] = cordic_fixed( w, mode, bit_wide, order);
        if ( err > max_err)
            max_err = err;
        end
        results.w = [ results.w; w];
        results.x = [ results.x; value];
        errs = [errs, err];
    end
else
    %two scan values
    for loop1 = 1:step
        for loop2 = 1:step
            w = [domain(loop1); domain(loop2)];
            [value, real_value, err, mid_results, ek] = cordic_fixed( w, mode, bit_wide, order);
            if ( err > max_err)
                max_err = err;
            end
            errs = [errs, err];
            results.w = [ results.w; w];
            results.x = [ results.x; value];
        end
    end
end