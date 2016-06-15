address = 16;
%[0,1)
factor = 0;
step = 2^(address - factor);
err_limitation = 1e-3;
mode = 2;
order = 12;
bit_limitation = 16;

[bit_wide, max_err, results, ek, errs, special_value] = cordic_fixed_scan( step, order, err_limitation, mode, bit_limitation);

searched_bit_wide = bit_wide
Maximum_errors = max_err

%Test Vector File
%tan value
file_tv = 'tan_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:length(results.w)
    value = floor(results.w(loop1) * (2^ hex_width));
    fprintf(file, '%s\n', dec2hex(value, ceil(hex_width/4)));
end
fclose(file);

%atan
file_tv = 'atan_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:length(results.w)
    value = floor(results.x(loop1) * (2^ bit_wide));
    if (value < 0)
        value = (2^ bit_wide) - value;
    end
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file);  

figure();
plot(results.w, results.x(:,1),'r-');
hold on;
grid on;

figure();
plot(results.w, errs,'r-');
grid on;