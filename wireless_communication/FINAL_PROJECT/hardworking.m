clc; clear; close all;

Fractional_Power = [0.189 0.379 0.239 0.095 0.061 0.037];
Delay = [0.0 0.2 0.5 1.6 2.3 5.0];
Doppler = ['CLASS' 'CLASS' 'CLASS' 'GAUS1' 'GUAS2' 'GUAS2'];

figure(1); 
fig1 = stem(Delay, Fractional_Power);
fig1.LineWidth = 1;
xlabel('Time Delay \tau (\mus)'); ylabel('Fractional Power');
title('6-rays Reduced Typical Urban');
saveas(gcf,'Result\6-rays Reduced Typical Urban.jpg')
