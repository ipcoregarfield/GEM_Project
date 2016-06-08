function [order, max_err] = cordic_float_scan( step, err_limitation,mode)
%Whole angle scan for CORDIC algorithm
%Input: step: #step in the value domain
%       err_limitation: allowed maximum error
%       mode: CORDIC mode
%            mode(1): corate mode
%                     trianle for 1; linear for 2; hyperbolic for 3;
%            mode(2): ending mode
%                     z to 0 for 1; y to 0 for 2
%Output: max_err: maximum error
%        order: CORDIC order to reach the error limitation



if (mode(1) == 1)
    if (mode(2) == 1)
        %result: x_k = cos(w) and y_k = sin(w)
        %value domain :[0, pi/4], considering the symmetry
        domain = 0:pi/4/(step-1):pi/4;
    else
        %result: x_k = K*sqrt(1 + w^2) and z_k = atan(w)
        %value domain :[0, 1], considering the symmetry
        domain = 0:1/(step-1):1;
    end
elseif (mode(1) == 2)
    %result: w(1) = a, w(2) = b, w(3) = c
    if (mode(2) == 1)
        % x_k = a and y_k = c+a*b
        %value domain :[0, 1], considering the symmetry
        domain =  0:1/(step-1):1;
    else
        %x_k = a and z_k = c+b/a
        %value domain :[0, 1], considering the symmetry
        domain =0:1/(step-1):1;
    end
else
    if (mode(2) == 1)
        %result: x_k = cosh(w) and y_k = sinh(w)
        %value domain :[0, 10], considering the symmetry
        domain = 0 :10/(step-1):10;
    else
        %result: x_k = K*sqrt(1 - w^2) and z_k = atanh(w)
        %value domain :[0, 5], considering the symmetry
        domain = 0:5/(step-1):5;
    end
end

max_order = 0;
if (mode(1) ~= 2)
    %single scan value
    for loop1 = 1:step
        [value, real_value, err, order] = cordic_float( domain(loop1), err_limitation,mode);
        if ( order > max_order)
            max_order = order;
        end
    end
else
    %three scan values
    if (mode(2) == 2)
        %a can not be 0
        start1 = 2;
    else
        start1 = 1;
    end
    
    for loop1 = start1:step
        for loop2 = 1:step
            for loop3 = 1:step
                w = [domain(loop1); domain(loop2);domain(loop3)];
                [value, real_value, err, order] = cordic_float( w, err_limitation,mode);
                if ( order > max_order)
                    max_order = order;
                end
            end
        end
    end
end

max_err = 0;
if (mode(1) ~= 2)
    %single scan value
    for loop1 = 1:step
        [value, real_value, err] = cordic_float_order( domain(loop1), max_order,mode);
        if ( err > max_err)
            max_err = err;
        end
    end
else
    %three scan values
    if (mode(2) == 2)
        %a can not be 0
        start1 = 2;
    else
        start1 = 1;
    end
    
    for loop1 = start1:step
        for loop2 = 1:step
            for loop3 = 1:step
                w = [domain(loop1); domain(loop2);domain(loop3)];
                [value, real_value, err] = cordic_float_order( w, max_order+1,mode);
                if ( err > max_err)
                    max_err = err;
                end
            end
        end
    end
end