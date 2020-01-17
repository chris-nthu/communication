clc; clear; close all;

%% power delay profiles for reduced typical urban
FractionalPower = [0.189 0.379 0.239 0.095 0.061 0.037];
Delay = [0.0 0.2 0.5 1.6 2.3 5.0]*10^(-6);
DopplerCategory = ['CLASS' 'CLASS' 'CLASS' 'GAUS1' 'GUAS2' 'GUAS2'];

%% parameter configurations
M = 16;                         % number of oscillator
v = 90;                         % MS velocity (km/hr)
fc = 2*10^9;                    % carrier frequency
c = 3*10^8;                     % light velocity
fm = ((v*1000)/(3600*c))*fc;    % maximum doppler shift
Ts = 10^(-3);                   % sampling duration (s/sample)
SamplingRatio = 10^(-4);
Ts_prime = SamplingRatio * Ts;
fmT = fm*Ts;
t = 8;                          % operation time
time = 0:0.1:t;
NumSamples = 5000;              % sample points
A = hadamard(M);                % M*M hadamard matrix

%% Combine 6 taps
g1 = CLASS(A(1,:), FractionalPower(1), Delay(1)/Ts_prime, M, fm, Ts, NumSamples); % 1st tap (CLASS)
g2 = CLASS(A(2,:), FractionalPower(2), Delay(2)/Ts_prime, M, fm, Ts, NumSamples); % 2nd tap (CLASS)
g3 = CLASS(A(3,:), FractionalPower(3), Delay(3)/Ts_prime, M, fm, Ts, NumSamples); % 3rd tap (CLASS)
g4 = GAUS1(A(4,:), FractionalPower(4), Delay(4)/Ts_prime, M, fm, Ts, NumSamples); % 4th tap (GAUS1)
g5 = GAUS2(A(5,:), FractionalPower(5), Delay(5)/Ts_prime, M, fm, Ts, NumSamples); % 5th tap (GAUS2)
g6 = GAUS2(A(6,:), FractionalPower(6), Delay(6)/Ts_prime, M, fm, Ts, NumSamples); % 6th tap (GAUS2)

g = g1 + g2 + g3 + g4 + g5 + g6;       % combine 6 taps with uncorrelated fading
g_magnitude = abs(g);                  % the magnitude of the channel

%% Power Delay Profiles
figure;
stem(Delay, FractionalPower, 'linewidth', 1); grid on;
xlabel('Time Delay \tau (\mus)'); ylabel('Fractional Power');
title('6-rays Reduced Typical Urban');
saveas(gcf,'Result\6-rays Reduced Typical Urban.jpg');

%% Fading Gain Distribution
figure;
hist(20*log(g_magnitude), NumSamples); grid on;
xlabel('Fading Gain (dB)'); ylabel('Number of Samples');
title('Fading Gain Distribution');
saveas(gcf,'Result\Fading Gain Distribution.jpg');

%% Time Domain : Strength Profile
figure;
plot(1:1:1000, 20*log(g_magnitude(1:1000)), 'linewidth', 1); grid on;
xlabel('Time (t/T)'); ylabel('Envelop Level (dB)');
title('Time domain Strength Profile');
saveas(gcf,'Result\Time domain Stength Profile.jpg');

figure;
plot(1:1:1000, 20*log(abs(g1(1:1000))), 'linewidth', 1); grid on;
xlabel('Time (t/T)'); ylabel('Envelop Level (dB)');
title('Time domain Strength Profile of CLASS');
saveas(gcf,'Result\Time domain Strength Profile of CLASS.jpg');

figure;
plot(1:1:1000, 20*log(abs(g4(1:1000))), 'linewidth', 1); grid on;
xlabel('Time (t/T)'); ylabel('Envelop Level (dB)');
title('Time domain Strength Profile of GAUS1');
saveas(gcf,'Result\Time domain Strength Profile of GAUS1.jpg');

figure;
plot(1:1:1000, 20*log(abs(g5(1:1000))), 'linewidth', 1); grid on;
xlabel('Time (t/T)'); ylabel('Envelop Level (dB)');
title('Time domain Strength Profile of GAUS2');
saveas(gcf,'Result\Time domain Strength Profile of GAUS2.jpg');

%% Time Domain : Auto-Correlation
[autocorrCLASS,lags] = xcorr(g1,'coeff');
autocorrCLASS = autocorrCLASS(lags >= 0);
[autocorrGAUS1,lags] = xcorr(g4,'coeff');
autocorrGAUS1 = autocorrGAUS1(lags >= 0);
[autocorrGAUS2,lags] = xcorr(g5,'coeff');
autocorrGAUS2 = autocorrGAUS2(lags >= 0);
[autocorr_g,lags] = xcorr(g,'coeff');
autocorr_g = autocorr_g(lags >= 0);

figure;
plot(time, real(autocorrCLASS(1:length(time))),'k' ,'linewidth', 2);
hold on;
plot(time, real(autocorrGAUS1(1:length(time))),'b:', 'linewidth', 2);
plot(time, real(autocorrGAUS2(1:length(time))),'r--', 'linewidth', 2);
grid on;
xlabel('Time Delay, f_m\tau'); ylabel('Auto-Correlation');
title('Auto-Correlation of each type of Doppler Spectrum');
legend('CLASS', 'GAUS1', 'GAUS2');
saveas(gcf,'Result\Auto-Correlation of each type of Doppler Spectrum.jpg');

figure;
plot(time, real(autocorr_g(1:length(time))), 'linewidth', 1); grid on;
ylim([-1,1]);
xlabel('Time Delay, f_m\tau'); ylabel('Auto-Correlation');
title('Time domain Auto-Correlation of the 6-tap combination');
saveas(gcf,'Result\Time domain Auto-Correlation of the 6-tap combination.jpg');

%% Time Domain : Crossing rate and Fade durarion
level_dB=-20:20; % dB
level=10.^(level_dB./10);
cross_rate=zeros(1,length(level));
fade_durarion=zeros(1,length(level));
i=0;
for kk=level
    cross_num=0;
    i=i+1;
    for index=1:length(g_magnitude)-1
        if (g_magnitude(index) < kk)&&(g_magnitude(index+1) > kk)
            cross_num=cross_num+1;
        end
        if (g_magnitude(index) < kk)&&(g_magnitude(index+1) < kk)
            fade_durarion(1,i)=fade_durarion(1,i)+1;
        end
    end
    cross_rate(1,i)=cross_num/(length(g_magnitude)-1);
end
figure;
semilogy(level_dB,cross_rate); grid on;
ylim([10^(-4), 10^0]);
xlabel('Level (dB)');ylabel('Level crossing rate');
title('Level Crossing Rate');
saveas(gcf,'Result\Level Crossing Rate.jpg');

figure;
plot(level_dB,fade_durarion.*(t/(NumSamples-100)), 'linewidth', 1); grid on;
xlabel('Level (dB)'); ylabel('Envelope fade durarion (sec)');
title('Average Fade durarion');
saveas(gcf,'Result\Average Fade Duration.jpg');

%% Frequency Domain: Strength Profile 
g_freqdomain = fft(g); %the fourier transform of the input signal

figure;
freq = 0:1/(Ts*length(g)):1/Ts;
plot(freq(1:ceil(length(g_freqdomain)/2)),20*log(abs(g_freqdomain(1:ceil(length(g_freqdomain)/2)))), 'linewidth', 1); grid on;
xlabel('Frequency (f/f_m)'); ylabel('Envelop Level (dB)');
title('Frequency-domain Strength Profile');
saveas(gcf,'Result\Frequency-domain Strength Profile.jpg');

%% Frequency Domain : Auto-Correlation
total_tau = 200;
autocorr_combine = autocorr(g_freqdomain, total_tau);
figure;
tau_f = 0:length(autocorr_combine)-1;
tau_f=(-100) * tau_f./(t/NumSamples-100);
plot(tau_f, autocorr_combine, 'linewidth', 1.5); grid on;
xlabel('Frequency (Hz)'); ylabel('Auto-Correlation');
title('Frequency Domain Auto-Correlation of 6 taps combination'); xlim([0 200]);
saveas(gcf,'Result\Frequency Domain Auto-Correlation of 6 taps combination.jpg');

%% Frequency Domain : Coherence Bandwidth
AvgDelay = sum(Delay.*FractionalPower)/sum(FractionalPower); 
RmsDelaySpread = sqrt(sum(((Delay-AvgDelay).^2).*FractionalPower)/sum(FractionalPower)); 
CoherentBW = 1/RmsDelaySpread;
disp(['Delay Spread = ',num2str(RmsDelaySpread), ';  Coherent Bandwidth = ', num2str(CoherentBW)])

%% Cross-Corelation Between Different Taps
[CrossCorrTap1_4,lags] = xcorr(g1,g4,'coeff');
CrossCorrTap1_4 = CrossCorrTap1_4(lags >= 0);
[CrossCorrTap4_5,lags] = xcorr(g4,g5,'coeff');
CrossCorrTap4_5 = CrossCorrTap4_5(lags >= 0);
[CrossCorrTap1_5,lags] = xcorr(g1,g5,'coeff');
CrossCorrTap1_5 = CrossCorrTap1_5(lags >= 0);

figure;
plot(time, real(CrossCorrTap1_4(1:length(time))),'k-' ,'linewidth', 1);
hold on; grid on;
plot(time, real(CrossCorrTap4_5(1:length(time))),'b:', 'linewidth', 1);
plot(time, real(CrossCorrTap1_5(1:length(time))),'r--', 'linewidth', 1);
xlabel('Time Delay, f_m\tau'); ylabel('Cross-Correlation');
title('Cross-Correlation Between Different paths');
legend('tap1 & tap4', 'tap4 & tap5', 'tap1 & tap5');
ylim([-1 1]);
saveas(gcf,'Result\Cross-Correlation Between Different paths.jpg');
