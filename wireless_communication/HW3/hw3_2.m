clear all;
clc;

fmT = [0.01, 0.1, 0.5];
M = [8, 16];
N = (2*M+1) * 2;
gi_1 = zeros(6, 5000);
gq_1 = zeros(6, 5000);
g = zeros(6, 5000);
gi = zeros(6, 5000);
gq = zeros(6, 5000);
t = [1:1:5000];

for k=1:2
    for i=1:3
        for n=1:M(1,k)
            gi_1(i+3*(k-1),:) = gi_1(i+3*(k-1),:) + cos(pi*n/M(1,k)) * cos(2*pi*fmT(1,i) * t * cos(2*pi*n/N(1,k)));
            gq_1(i+3*(k-1),:) = gq_1(i+3*(k-1),:) + sin(pi*n/M(1,k)) * cos(2*pi*fmT(1,i) * t * cos(2*pi*n/N(1,k)));
        end
    end
end

gi_1 = gi_1 * 2 * sqrt(2);
gq_1 = gq_1 * 2 * sqrt(2);

for i=1:3
    gi(i, :)     = gi_1(i, :) + 2 * cos(2*pi*fmT(1,i)*t);
    gi(i+3, :)   = gi_1(i+3,:) + 2 * cos(2*pi*fmT(1,i)*t);
end

gq = gq_1;

for i=1:6
    g_db(i,:) = 10 * log10(sqrt(gi(i,:).^2+gq(i,:).^2));
    g(i,:) = gi(i,:) + 1i * gq(i,:);
end

g_autocorr1 = autocorr(g(1,:), 10/fmT(1,1));
g_autocorr2 = autocorr(g(2,:), 10/fmT(1,2));
g_autocorr3 = autocorr(g(3,:), 10/fmT(1,3));
g_autocorr4 = autocorr(g(4,:), 10/fmT(1,1));
g_autocorr5 = autocorr(g(5,:), 10/fmT(1,2));
g_autocorr6 = autocorr(g(6,:), 10/fmT(1,3));

figure(1);
fig1 = plot(t(1:300), g_db(1,1:300));
fig1.LineWidth = 0.8;
set(fig1, 'color', 'r');
xlabel('Time t/T'); ylabel('envelope of g (dB)');
title('Envelope Model with fmT = 0.01 & M = 8');

figure(2);
fig2 = plot([0:fmT(1,1):10], g_autocorr1);
fig2.LineWidth = 0.8;
set(fig2, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau)');
title('Autocorrelation with fmT = 0.01 & M = 8');

figure(3);
fig3 = plot(t(1:300), g_db(2,1:300));
fig3.LineWidth = 0.8;
set(fig3, 'color', 'r');
xlabel('Time t/T'); ylabel('envelope of g (dB)');
title('Envelope Model with fmT = 0.1 & M = 8');

figure(4);
fig4 = plot([0:fmT(1,2):10], g_autocorr2);
fig4.LineWidth = 0.8;
set(fig4, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau)');
title('Autocorrelation with fmT = 0.1 & M = 8');

figure(5);
fig5 = plot(t(1:300), g_db(3,1:300));
fig5.LineWidth = 0.8;
set(fig5, 'color', 'r');
xlabel('Time t/T'); ylabel('envelope of g (dB)');
title('Envelope Model with fmT = 0.5 & M = 8');

figure(6);
fig6 = plot([0:fmT(1,3):10], g_autocorr3);
fig6.LineWidth = 0.8;
set(fig6, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau)');
title('Autocorrelation with fmT = 0.5 & M = 8');

figure(7);
fig7 = plot(t(1:300), g_db(4,1:300));
fig7.LineWidth = 0.8;
set(fig7, 'color', 'r');
xlabel('Time t/T'); ylabel('envelope of g (dB)');
title('Envelope Model with fmT = 0.01 & M = 16');

figure(8);
fig8 = plot([0:fmT(1,1):10], g_autocorr4);
fig8.LineWidth = 0.8;
set(fig8, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau)');
title('Autocorrelation with fmT = 0.01 & M = 16');

figure(9);
fig9 = plot(t(1:300), g_db(5,1:300));
fig9.LineWidth = 0.8;
set(fig9, 'color', 'r');
xlabel('Time t/T'); ylabel('envelope of g (dB)');
title('Envelope Model with fmT = 0.1 & M = 16');

figure(10);
fig10 = plot([0:fmT(1,2):10], g_autocorr5);
fig10.LineWidth = 0.8;
set(fig10, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau)');
title('Autocorrelation with fmT = 0.1 & M = 16');

figure(11);
fig11 = plot(t(1:300), g_db(6,1:300));
fig11.LineWidth = 0.8;
set(fig11, 'color', 'r');
xlabel('Time t/T'); ylabel('envelope of g (dB)');
title('Envelope Model with fmT = 0.5 & M = 16');

figure(12);
fig12 = plot([0:fmT(1,3):10], g_autocorr6);
fig12.LineWidth = 0.8;
set(fig12, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau)');
title('Autocorrelation with fmT = 0.5 & M = 16');
