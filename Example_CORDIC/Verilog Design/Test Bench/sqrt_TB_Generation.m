address = 8;
%[1,10]
factor = 0;
step = 2^(address - factor);
err_limitation = 1e-3;
mode = 3;
order = 12;
bit_limitation = 16;

[bit_wide, max_err, results, ek, errs, special_value] = cordic_fixed_scan( step, order, err_limitation, mode, bit_limitation,0);

searched_bit_wide = bit_wide
Maximum_errors = max_err

bit_wide = bit_wide + 7;
%Test Vector File
%a value
file_tv = 'a_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:length(results.w)
    value = floor(results.w(loop1, 1));
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file);

%b value
file_tv = 'b_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:length(results.w)
    value = floor(results.w(loop1, 2) );
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file);

%sqrt
file_tv = 'sqrt_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:length(results.w)
    value = floor(results.x(loop1) );
    if (value < 0)
        value = (2^ bit_wide) - value;
    end
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file);  

figure();
plot3(results.w(:,1)/(2^bit_wide), results.w(:,2)/(2^bit_wide), results.x(:,1)/(2^bit_wide),'r-');
hold on;
grid on;

figure();
plot(errs,'r-');
grid on;