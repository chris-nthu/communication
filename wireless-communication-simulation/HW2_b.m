clc; clear;

v = 90000/3600;
c = 3 * 10^8;
fc = 26 * 10^9;
wavelength = c / fc;
fm = v / wavelength;
numbers_of_sample = 100000;

incidence_angle = -pi + 2*pi * rand(numbers_of_sample, 1);

x_axis = linspace(-fm, fm, 2*fm+1);

doppler_frequency_shift = fm * cos(incidence_angle);

test = -fm; prob = [];

while test < fm
    count = 0;
    for i = 1:numbers_of_sample
        if (doppler_frequency_shift(i) > test) & (doppler_frequency_shift(i) < test + 1)
            count = count + 1
        end
    end
    prob(end+1) = count / numbers_of_sample;

    test = test + 1
end

S = sum(prob);

figure(1);
plot(x_axis, prob);
figure(2);
[f,x] = ecdf(doppler_frequency_shift); plot(x,f);
