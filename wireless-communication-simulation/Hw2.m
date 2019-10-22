v = 20;
c = 3 * 10^8;
fc = 2 * 10^9;
wavelength = c / fc;
fm = v / wavelength;

incidence_angle = -2 * pi + 4 * pi * rand(1000000, 1);

x_axis_min = fm * cos(pi);
x_axis_max = fm * cos(0);

x_axis = linspace(x_axis_min, x_axis_max, 267);

doppler_frequency_shift = fm * cos(incidence_angle);

count = 0;
test = x_axis_min;
prob = [];

while test < x_axis_max
    for i = 1:1000000
        if (doppler_frequency_shift(i) > test) & (doppler_frequency_shift(i) < test + 1)
            count = count + 1
        end
    end
    prob(end+1) = count;
    count = 0;
    test = test + 1
end

prob = prob / 1000000;
plot(x_axis, prob);


