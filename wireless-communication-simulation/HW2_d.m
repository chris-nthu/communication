clear; clc;

v = 20000/3600;
c = 3 * 10^8;
fc = 2 * 10^9;
wavelength = c / fc;
fm = v / wavelength;
y = [-fm:0.1:fm]
pdf = 1 ./ (pi * sqrt(fm^2 - y.^2));
cdf = acos(-y./fm)/pi;
cdf = cdf./cdf(end);

figure(1); plot(y, pdf);
figure(2); plot(y, cdf);