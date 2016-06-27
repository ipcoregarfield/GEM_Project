step = 360;
err_limitation = 1e-4;
mode = [1,1];

[order, max_err] = cordic_float_scan( step, err_limitation,mode)

values = [];
errs =[];
domain = 0:pi/2/(2*step-1):pi/2;
for loop1 = 1: 2*step
    [value, real_value, err] = cordic_float_order( domain(loop1), order,mode);
    values=[values; value];
    errs =[errs; err];
end

figure();
plot(domain, values(:,1),'r-');
hold on;
plot(domain, values(:,2),'b-');
grid on;

figure();
plot(domain, errs,'r-');
grid on;

max_err = max(errs)