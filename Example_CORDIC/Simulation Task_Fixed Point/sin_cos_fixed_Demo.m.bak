step = 360;
err_limitation = 1e-3;
mode = 1;
order = 12;
bit_limitation = 16;

[bit_wide, max_err, results, ek, errs, special_value] = cordic_fixed_scan( step, order, err_limitation, mode, bit_limitation);

searched_bit_wide = bit_wide
Maximum_errors = max_err

figure();
plot(results.w, results.x(:,1),'r-');
hold on;
plot(results.w, results.x(:,2),'b-');
grid on;

figure();
plot(results.w, errs,'r-');
grid on;