clear; clc;

v = 20000 / 3600;
c = 3 * 10^8;
fc = 2 * 10^9;
wavelength = c / fc;
fm = v / wavelength;
samples_number = 1000000;
intervals_number = 100;

incidence_angle = -pi + 2 * pi * rand(1, samples_number);

doppler_frequency_shift = fm * cos(incidence_angle);

[y, x] = hist(doppler_frequency_shift, intervals_number);
figure(1);
plot(x, y./samples_number);
xlabel('Doppler frequency shift (x)');
ylabel('f(x)');
title('Probability Density Function');
grid on;
figure(2)
cdfplot(doppler_frequency_shift);
xlabel('Doppler frequency shift (x)');
title('Cumulative Distribution Function');
