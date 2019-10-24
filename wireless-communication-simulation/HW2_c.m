clc; clear;

%v = 20000/3600;
c = 3 * 10^8;
fc = 2 * 10^9;
wavelength = c / fc;
%fm = v / wavelength;
numbers_of_sample = 100000;

%incidence_angle = -pi + 2*pi * rand(numbers_of_sample, 1);

x_axis = linspace(-fm, fm, 2*fm+1);

doppler_frequency_shift = [];

for i=1:numbers_of_sample
    doppler_frequency_shift(end+1) = (((20000/3600)+(70000/3600)*rand())/wavelength) * cos(-pi+2*pi*rand());

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

figure(1);
plot(x_axis, prob);
figure(2);
[f,x] = ecdf(doppler_frequency_shift); plot(x,f);
