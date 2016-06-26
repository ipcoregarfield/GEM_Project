address = 16;
%2*pi to pi/4
factor = 8;
step = 2^(address - factor);
err_limitation = 1e-3;
mode = 1;
order = 12;
bit_limitation = 16;
sample_angle = 0.25;

[bit_wide, max_err, results, ek, errs, special_value] = cordic_fixed_scan( step, order, err_limitation, mode, bit_limitation, sample_angle);

searched_bit_wide = bit_wide
Maximum_errors = max_err

%Test Vector File
%angle
file_tv = 'angle_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:length(results.w)
    value = floor(results.w(loop1));
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file);

%sin
file_tv = 'sin_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:length(results.w)
    value = floor(results.x(loop1,2));
    if (value < 0)
        value = (2^bit_wide) - value + 1;
    end
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file);  

%cos
file_tv = 'cos_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:length(results.w)
    value = floor(results.x(loop1,1) );
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file); 

file_tv = 'triangle_x_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:order+2
    value = results.mid_results.x(loop1);
    if (value < 0)
        value = (2^ (bit_wide+1)) + value;
    end
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file); 

file_tv = 'triangle_y_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:order+2
    value = results.mid_results.y(loop1);
    if (value < 0)
        value = (2^ (bit_wide+1)) + value;
    end
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file); 

file_tv = 'triangle_z_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:order+2
    value = results.mid_results.z(loop1);
    if (value < 0)
        value = (2^ (bit_wide+1)) + value;
    end
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file); 

file_tv = 'triangle_K_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
value = results.x0;
fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
fclose(file); 

file_tv = 'triangle_ek_test_vector';
file_tv = strcat(file_tv, '.txt');
hex_width = address - factor;
file = fopen(file_tv,'w');
for loop1 = 1:order+1
    value = results.ek(loop1);
    if (value < 0)
        value = (2^ (bit_wide+1)) + value;
    end
    fprintf(file, '%s\n', dec2hex(value, ceil(bit_wide/4)));
end
fclose(file);

figure();
plot(results.w, results.x(:,1)/(2^(bit_wide)),'r-');
hold on;
plot(results.w, results.x(:,2)/(2^(bit_wide)),'b-');
grid on;

figure();
plot(results.w, errs,'r-');
grid on;