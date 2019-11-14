clear all;
clc;

fmT = [0.01, 0.1, 0.5];

for i=1:3
    zeta(1, i)   = 2 - cos(pi*fmT(1,i)*(1/2)) - sqrt((2-cos(0.5*pi*fmT(1,i)))^2-1);
    var(1, i)   = ((1+zeta(1,i))/(1-zeta(1,i))) * (1/2);
    gi(i, 1)    = (1-zeta(1,i)) * randn(1) * sqrt(var(1,i));
    gq(i, 1)    = (1-zeta(1,i)) * randn(1) * sqrt(var(1,i));
    g(i, 1)     = sqrt(gi(i,1)^2+gq(i,1)^2);
end

for i=1:3
    for t=2:1:5000
        gi(i, t)    = zeta(1,i) * gi(i,t-1) + (1-zeta(1,i)) * randn(1) * sqrt(var(1,i));
        gq(i, t)    = zeta(1,i) * gq(i,t-1) + (1-zeta(1,i)) * randn(1) * sqrt(var(1,i));
        g(i, t)     = sqrt(gi(i,t)^2+gq(i,t)^2);
    end
end

g_db = 10 * log10(g);

g_autocorr1 = autocorr(gi(1,:),10/fmT(1,1));
g_autocorr2 = autocorr(gi(2,:),10/fmT(1,2));
g_autocorr3 = autocorr(gi(3,:),10/fmT(1,3));

time = [1:300];
figure(1);
fig1 = plot(time, g_db(1, 1:300));
fig1.LineWidth = 0.8;
set(fig1, 'color', 'r');
xlabel('Time t/T'); ylabel('Envelope of g (dB)');
title('Envelope Model with fmT = 0.01');

figure(2);
fig2 = plot([0:fmT(1,1):10], g_autocorr1);
fig2.LineWidth = 0.8;
set(fig2, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau) = gii(\tau)');
title('Autocorrelation with fmT = 0.01');

figure(3);
fig3 = plot(time, g_db(2, 1:300));
fig3.LineWidth = 0.8;
set(fig3, 'color', 'r');
xlabel('Time t/T'); ylabel('Envelope of g (dB)');
title('Envelope Model with fmT = 0.1');

figure(4);
fig4 = plot([0:fmT(1,2):10], g_autocorr2);
fig4.LineWidth = 0.8;
set(fig4, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau) = gii(\tau)');
title('The Autocorrelation with fmT = 0.1');

figure(5);
fig5 = plot(time, g_db(3, 1:300));
fig5.LineWidth = 0.8;
set(fig5, 'color', 'r');
xlabel('Time t/T'); ylabel('Envelope of g (dB)');
title('Envelope Model with fmT = 0.5');

figure(6);
fig6 = plot([0:fmT(1,3):10], g_autocorr3);
fig6.LineWidth = 0.8;
set(fig6, 'color', 'r');
xlabel('Time Delay fm\tau'); ylabel('Autocorrelation of g(\tau) = gii(\tau)');
title('Autocorrelation with fmT = 0.5');
