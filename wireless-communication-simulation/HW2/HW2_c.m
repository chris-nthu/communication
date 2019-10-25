clear; clc;

samples_number = 100000; intervals_number = floor((90000/3600)/0.15)*2;
fc = 2 * 10^9;
wavelength = 3 * 10^8 / fc;

doppler_frequency_shift = [];

for i=1:samples_number
    doppler_frequency_shift(end+1) = (((20000/3600)+(70000/3600)*rand())/wavelength)*cos(-pi+2*pi*rand());
end

[y, x] = hist(doppler_frequency_shift, intervals_number);
figure(1);
plot(x, y./samples_number);
xlabel('Doppler frequency shift (x)'); ylabel('f(x)');
title('Probability Density Function');
grid on;
figure(2);
cdfplot(doppler_frequency_shift);
xlabel('Doppler frequency shift (x)');
title('Cumulative Distribution Function');