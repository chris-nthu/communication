%% Wireless Communications Final Project (COST 207 Channel Emulator)
% ID: 103064510
% Name: Chia-Yu Liu
clear all; close all; clc;

%% Parameter Setting


M = 16; % number of frequency oscillators
N = 4*M + 2; 
v =50; % Mobile speed (km/hr)
vv =  v* 1000/3600;  % km/hr to m/s    
fc = 2e9;                     % Carrier frequency (Hz)
c = 3e8;                      % Speed of light (m/s)
fm = vv*fc/c;                % Maximum Doppler shift (Hz)
Ts = 1e-3;                  % Sampling duation (s/sample)
SamplingRatio = 1e-4;
Ts_prime = SamplingRatio * Ts;
fmT = fm*Ts;              % maximum doppler shift * sampling duration


t = 8; % t = 5, if v = 120 km/hr, for better approximation of the auto-correlation function
time = 0:0.1:t;
NumSamples = 5000;      % sample points



%% Power delay profile for reduced typical urban
% Doppler category : [CLASS, CLASS, CLASS, GAUS1, GAUS2,GAUS2]
delay = [0, 0.2, 0.5, 1.6, 2.3, 5] *1e-6; % each tap delay (s)
fractionalPower = [0.189, 0.379, 0.239, 0.095, 0.061, 0.037]; % each tap gain

%% Combine 6 taps signal with Walsh-Hadamard code
A = hadamard(M); % walsh-hadamard code

g1 = CLASS(A(1,:), fractionalPower(1), delay(1)/Ts_prime , M, fm,Ts, NumSamples); % 1st tap
g2 = CLASS(A(2,:), fractionalPower(2), delay(2)/Ts_prime , M, fm,Ts, NumSamples); % 2nd tap
g3 = CLASS(A(3,:), fractionalPower(3), delay(3)/Ts_prime , M, fm,Ts, NumSamples); % 3rd tap
g4 = GAUS1(A(4,:), fractionalPower(4), delay(4)/Ts_prime , M, fm,Ts, NumSamples); % 4th tap
g5 = GAUS2(A(5,:), fractionalPower(5), delay(5)/Ts_prime , M, fm,Ts, NumSamples); % 5th tap
g6 = GAUS2(A(6,:), fractionalPower(6), delay(6)/Ts_prime , M, fm,Ts, NumSamples); % 6th tap

g = g1 + g2 + g3 + g4 + g5 + g6; % combine six taps with uncorrelated fading

g_magnitude = abs(g); % the magnitude of the channel

%% Time Domain: Strength Profile of each tap
figure
plot(201:1:500,20*log(abs(g1(201:500))),'k');
grid on
xlabel('Time, t/T', 'fontsize', 14);
ylabel('Envelop Level (dB)', 'fontsize' , 14)
title('Time-domain Strength Profile of CLASS', 'fontsize', 14);
set(gca,'fontsize',14)
%set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
%print(gcf, '-depsc', ['strength_time_class_v',num2str(v),'.eps']);

figure
plot(201:1:500,20*log(abs(g4(201:500))),'k');
grid on
xlabel('Time, t/T', 'fontsize', 14);
ylabel('Envelop Level (dB)', 'fontsize' , 14)
title('Time-domain Strength Profile of GAUS1', 'fontsize', 14);
set(gca,'fontsize',14)
%set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
%print(gcf, '-depsc', ['strength_time_gaus1_v',num2str(v),'.eps']);

figure
plot(201:1:500,20*log(abs(g5(201:500))),'k');
grid on
xlabel('Time, t/T', 'fontsize', 14);
ylabel('Envelop Level (dB)', 'fontsize' , 14)
title('Time-domain Strength Profile of GAUS2', 'fontsize', 14);
set(gca,'fontsize',14)
%set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
%print(gcf, '-depsc', ['strength_time_gaus2_v',num2str(v),'.eps']);


%% Power Delay Profile
figure;
stem(delay*1e6, fractionalPower,'k', 'linewidth', 3,'MarkerSize', 10);
grid on
xlabel('Time Delay (\mus)', 'fontsize', 14);
ylabel('Fractional Power', 'fontsize', 14);
title('Reduced Typical Urban Delay Profile', 'fontsize', 14);
set(gca,'fontsize',14)
%set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
%print(gcf, '-depsc', 'power_delay_profile.eps');

%% Fading Gain Distribution
figure;
hist(20*log(g_magnitude), NumSamples,'k');
grid on
xlabel('Fading Gain (dB)', 'fontsize', 14)
ylabel('Number of Samples', 'fontsize',14) 
title('Fading Gain Distrubution', 'fontsize', 14)
set(gca,'fontsize',14)
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['fading_gain_distribution_v',num2str(v),'.eps']);

%% Time Domain: Strength Profile
figure
plot(1:1:300,20*log(g_magnitude(1:300)),'k');
grid on
xlabel('Time, t/T', 'fontsize', 14);
ylabel('Envelop Level (dB)', 'fontsize' , 14)
title('Time-domain Strength Profile', 'fontsize', 14);
set(gca,'fontsize',14)
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['strength_time_v',num2str(v),'.eps']);

%% Time Domain: Autocorrelation 
 [autocorr_g,lags] = xcorr(g,'coeff');
 autocorr_g = autocorr_g(lags >= 0);
figure
plot(time, real(autocorr_g(1:length(time))),'k-', 'linewidth', 3);
ylim([-1,1]);
grid on
xlabel('Time Delay, f_m\tau', 'fontsize', 14)
ylabel('Auto-Correlation', 'fontsize', 14)
title('Auto-Correlation in Time Domain', 'fontsize', 14)
set(gca, 'fontsize', 14)
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['autocorr_channel_time_v',num2str(v),'.eps']);

%% Time Domain: Level Crossing Rate and Average Fade Duration

Threshold = -20:5:20; % dB
NumDownCrossing = zeros(length(Threshold),1);
NumUpCrossing = zeros(length(Threshold),1);
CrossingRate = zeros(length(Threshold),1);
AvgFadeDuration = zeros(length(Threshold),1);

for trial = 1:length(Threshold),
    DownLocation = 0; % initialize
    FadeDuration = 0; % initialize
    for i = 1:length(g_magnitude)-1,
        if(20*log(g_magnitude(i)) > Threshold(trial) && 20*log(g_magnitude(i+1)) < Threshold(trial)), % find the crossing point (down crossing)
            NumDownCrossing(trial) = NumDownCrossing(trial) + 1;
            DownLocation = i; % mark the location of the fade
        elseif (20*log(g_magnitude(i)) < Threshold(trial) && 20*log(g_magnitude(i+1)) > Threshold(trial)),% find the crossing point (up crossing)
            NumUpCrossing(trial) = NumUpCrossing(trial) + 1;
            Duration = i - DownLocation; % evaluate the fade duration
            FadeDuration = [FadeDuration, abs(Duration)];
        end;
    end;
    FadeDuration(1) = []; % clear the initial term
    CrossingRate(trial) = NumDownCrossing(trial) / (length(g_magnitude)-1);
    AvgFadeDuration(trial) = mean(FadeDuration);
    clear FadeDuration
end;

figure
plot(Threshold, CrossingRate/Ts, 'k-o' , 'linewidth' , 3,'MarkerSize', 10);
grid on
xlim([-20, 20]);
xlabel('Threshold (dB)', 'fontsize' ,14);
ylabel('Level Crossing Rate (fades/s)' , 'fontsize' , 14);
title('Crossing Rate', 'fontsize' ,14);
set(gca, 'fontsize', 14);
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['crossingrate_v',num2str(v),'.eps']);

figure
plot(Threshold, AvgFadeDuration*Ts, 'k-o' , 'linewidth' , 3,'MarkerSize', 10);
grid on
xlim([-20, 20]);
xlabel('Threshold (dB)', 'fontsize' ,14);
ylabel('Average Fade Duration (s/fade)' , 'fontsize' , 14);
title('Average Fade Duration', 'fontsize' ,14);
set(gca, 'fontsize', 14);
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['avgfade_duration_v',num2str(v),'.eps']);

%% Time Domain: Coherence Time and Doppler Spread
CoherentTime = 1/fm;
DopplerSpread = 1/CoherentTime;

disp(['Coherent Time = ',num2str(CoherentTime), ';  Doppler Spread = ', num2str(DopplerSpread)])

%% Frequency Domain: Strength Profile 
g_freqdomain = fft(g); %the fourier transform of the input signal
figure
freq = 0:1/(Ts*length(g)):1/Ts;
plot(freq(1:ceil(length(g_freqdomain)/2)),20*log(abs(g_freqdomain(1:ceil(length(g_freqdomain)/2)))),'k');
grid on
xlabel('Frequency', 'fontsize', 14);
ylabel('Envelop Level (dB)', 'fontsize' , 14)
title('Frequency-domain Strength Profile', 'fontsize', 14);
set(gca,'fontsize',14)
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['strength_freq_v',num2str(v),'.eps']);

%% Frequency Domain: Autocorrelation
G = fft(g);
GG = G.*conj(G); % convolution in time is equivalent to multiplication in frequency
autoG = ifft(GG);
autoG = autoG/max(autoG); % normalize

figure
plot(time, real(autoG(1:length(time))),'k-', 'linewidth' , 3);
ylim([-1,1]);
grid on
xlabel('Time Delay, f_m\tau', 'fontsize', 14)
ylabel('Auto-Correlation', 'fontsize', 14)
title('Auto-Correlation in Frequency Domain', 'fontsize', 14)
set(gca, 'fontsize', 14)
%set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
%print(gcf, '-depsc', ['autocorr_channel_freq_v',num2str(v),'.eps']);

%% Frequency Demain: Coherence Bandwidth

AvgDelay = sum(delay.*fractionalPower)/sum(fractionalPower); 
RmsDelaySpread = sqrt(sum(((delay-AvgDelay).^2).*fractionalPower)/sum(fractionalPower)); 
CoherentBW = 1/RmsDelaySpread;
disp(['Delay Spread = ',num2str(RmsDelaySpread), ';  Coherent Bandwidth = ', num2str(CoherentBW)])

%% Frequency Domain:  Power Spectrum
PSD_g = fft(autocorr_g(1:length(time))); %the fourier transform of the input signal

figure;
freq = 0:1/(Ts*length(time)):1/Ts;
plot(freq(1:ceil(length(PSD_g)/2)),10*log(real(PSD_g(1:ceil(length(PSD_g)/2)))),'k','linewidth',3);
grid on
xlabel('f (Hz)', 'fontsize', 14)
ylabel('Power Spectrum Density (dB)','fontsize', 14)
title('6-tap Channel Power Spectrum', 'fontsize' ,14)
set(gca,'fontsize',14)
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['psd_channel_v',num2str(v),'.eps']);

%% Cross-Corelation Between Different Taps
figure;
[CrossCorrTap1_4,lags] = xcorr(g1,g4,'coeff');
CrossCorrTap1_4 = CrossCorrTap1_4(lags >= 0);
[CrossCorrTap4_5,lags] = xcorr(g4,g5,'coeff');
CrossCorrTap4_5 = CrossCorrTap4_5(lags >= 0);
[CrossCorrTap1_5,lags] = xcorr(g1,g5,'coeff');
CrossCorrTap1_5 = CrossCorrTap1_5(lags >= 0);

plot(time, real(CrossCorrTap1_4(1:length(time))),'k-' ,'linewidth', 3);
hold on
plot(time, real(CrossCorrTap4_5(1:length(time))),'b:', 'linewidth', 3);
plot(time, real(CrossCorrTap1_5(1:length(time))),'r--', 'linewidth', 3);
grid on
xlabel('Time Delay, f_m\tau', 'fontsize' , 14)
ylabel('Cross-Correlation', 'fontsize', 14)
legend('tap1 & tap4', 'tap4 & tap5', 'tap1 & tap5')
set(gca,'fontsize',14)
ylim([-1 1])
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['crosscorr_v',num2str(v),'.eps']);


%% Auto-Correlation of each kind of Dopper spectrum

[autocorrCLASS,lags] = xcorr(g1,'coeff');
autocorrCLASS = autocorrCLASS(lags >= 0);
[autocorrGAUS1,lags] = xcorr(g4,'coeff');
autocorrGAUS1 = autocorrGAUS1(lags >= 0);
[autocorrGAUS2,lags] = xcorr(g5,'coeff');
autocorrGAUS2 = autocorrGAUS2(lags >= 0);

figure;
plot(time, real(autocorrCLASS(1:length(time))),'k-' ,'linewidth', 3);
hold on
grid on
plot(time, real(autocorrGAUS1(1:length(time))),'b:', 'linewidth', 3);
plot(time, real(autocorrGAUS2(1:length(time))),'r--', 'linewidth', 3);
xlabel('Time Delay, f_m\tau', 'fontsize' , 14)
ylabel('Auto-Correlation', 'fontsize', 14)
legend('CLASS', 'GAUS1', 'GAUS2')
set(gca,'fontsize',14)
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['autocorr_compareall_v',num2str(v),'.eps']);

%% Spectrum of each kind of Doppler Spectrum


% CLASS
fmindex = floor(fm * length(autocorrCLASS(1:length(time))) * Ts); % find the location of the maximum Doppler frequency
PSDCLASS = fft(autocorrCLASS(1:length(time))); %the fourier transform of the input signal

PSDCLASS(fmindex:length(autocorrCLASS(1:length(time)))-fmindex) = []; % remove the the value out of fm
if(mod(length(PSDCLASS),2) == 0 ), PSDCLASSv = [PSDCLASS(length(PSDCLASS)/2+1:end);PSDCLASS(1:length(PSDCLASS)/2)]; %shifting
else PSDCLASSv = [PSDCLASS((length(PSDCLASS)+1)/2:end);PSDCLASS(1:(length(PSDCLASS)+1)/2 -1)]; end; %shifting
% GAUS1
fmindex = floor(fm * length(autocorrGAUS1(1:length(time))) * Ts); % find the location of the maximum Doppler frequency
PSDGAUS1 = fft(autocorrGAUS1(1:length(time))); %the fourier transform of the input signal
PSDGAUS1(fmindex:length(autocorrGAUS1(1:length(time)))-fmindex) = []; % remove the the value out of fm
if(mod(length(PSDGAUS1),2) == 0 ), PSDGAUS1v = [PSDGAUS1(length(PSDGAUS1)/2+1:end);PSDGAUS1(1:length(PSDGAUS1)/2)]; %shifting
else PSDGAUS1v = [PSDGAUS1((length(PSDGAUS1)+1)/2:end);PSDGAUS1(1:(length(PSDGAUS1)+1)/2 -1)]; end;%shifting
% GAUS2
fmindex = floor(fm * length(autocorrGAUS2(1:length(time))) * Ts); % find the location of the maximum Doppler frequency
PSDGAUS2 = fft(autocorrGAUS2(1:length(time))); %the fourier transform of the input signal
PSDGAUS2(fmindex:length(autocorrGAUS2(1:length(time)))-fmindex) = []; % remove the the value out of fm
if(mod(length(PSDGAUS2),2) == 0 ), PSDGAUS2v = [PSDGAUS2(length(PSDGAUS2)/2+1:end);PSDGAUS2(1:length(PSDGAUS2)/2)]; %shifting
else PSDGAUS2v = [PSDGAUS2((length(PSDGAUS2)+1)/2:end);PSDGAUS2(1:(length(PSDGAUS2)+1)/2 -1)]; end;%shifting

figure; 
stem(linspace(-fm,fm,length(PSDCLASSv)),(abs(PSDCLASSv)),'k','linewidth',3, 'MarkerSize',10);
grid on
xlabel('f (Hz)', 'fontsize', 14)
ylabel('Power Spectrum Density','fontsize', 14)
title('CLASS', 'fontsize' ,14)
set(gca,'fontsize',14)
xlim([-fm, fm])
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['psd_class_v',num2str(v),'.eps']);

figure;
stem(linspace(-fm,fm,length(PSDGAUS1v)), (abs(PSDGAUS1v)),'k','linewidth',3, 'MarkerSize',10);
grid on
xlabel('f (Hz)', 'fontsize', 14)
ylabel('Power Spectrum Density','fontsize', 14)
title('GAUS1','fontsize',14)
xlim([-fm, fm])
set(gca,'fontsize',14)
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['psd_gaus1_v',num2str(v),'.eps']);

figure;
stem(linspace(-fm,fm,length(PSDGAUS2v)), (abs(PSDGAUS2v)),'k','linewidth',3, 'MarkerSize',10);
grid on
xlabel('f (Hz)', 'fontsize', 14)
ylabel('Power Spectrum Density','fontsize', 14)
title('GAUS2','fontsize',14)
set(gca,'fontsize',14)
% set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 6]);
% print(gcf, '-depsc', ['psd_gaus2_v',num2str(v),'.eps']);




