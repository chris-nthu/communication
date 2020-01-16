% Final project (v4) 100064505
clear; clc; close all;

% input parameters %
M=16; % M個oscilators
v=3000/3; % MS velocity (m/s)
L=6; % L個taps
total_time=1; % sec

tic
N=4*M+2;
sample=1e4+1; % 要跑的點數
T=total_time/(sample-1); % sec,t/T=0:1:(sample-1)
t=0:T:total_time; 

fc=900*(10^6); % fc=900MHz
lambda=(3*(10^8))/fc; 
fm=v/lambda;
fmT=fm*T;

tau=[0 2 5 16 23 50]; % unit:0.1us
frac_power=[0.189 0.379 0.239 0.095 0.061 0.037]; % fractional power
stem(tau./10,frac_power);
xlabel('Time delay \tau (\mus)');
ylabel('Fraction of power');
title('Typical Urban (TU)');

a1=[10 1];
a2=[1 31.6];
v11=[-0.8*fm 0.7*fm];
v21=[0.05*fm 0.1*fm];
v12=[0.4*fm -0.4*fm];
v22=[0.1*fm 0.15*fm];
osci_magn=zeros(2,M);
for kk=1:2
osci_sample=(-fm):2*fm/15:fm;
osci_magn(kk,:)=a1(kk).*exp(-((osci_sample-v11(kk)).^2)./(2*(v21(kk)^2)))+a2(kk).*exp(-((osci_sample-v12(kk)).^2)./(2*(v22(kk)^2)));
end

% Generate g_k(t)
H=hadamard(M);
gama=zeros(L,1);
theta=zeros(L,1); 
fn=zeros(M,1);
g=zeros(L,sample); % g_k(t)
for kk=1:L
    if ((kk==1) || (kk==2) || (kk==3)) % CLASS
        k=kk;
        for n=1:M
            beta=(pi*n)/(M+1);
            gama(k,:)=(2*pi*n*(k-1))/(M+1);
            theta(k,:)=beta+gama(k,1);
            theta_n=2*pi*n/N;
            fn(n,1)=fm*cos(theta_n); 
            for index=1:length(t) % t=0:T:total_time    
                g(k,index)=g(k,index)+2^(3/2)*H(k,n)*(cos(beta)+i*sin(beta))*cos(2*pi*fn(n,1)*((index-1)*T)+theta(k,:));
            end
        end
     
    elseif (kk==4) % GAUS1
            k=kk-3;
            tau_k=tau(kk);
            pre_g_k=zeros(M,length(t));
            for index=1:length(t) % t=0:T:total_time
                for n=1:M
                    pre_g_k(n,index)=osci_magn(1,n)*exp(i*2*pi*(fn(n,1)*((index-1)*T)-(fc+fn(n,1))*tau_k*10^(-7))); %tau_k???
                end
                g(kk,index)=sum(pre_g_k(:,index)); % 產生g_4(t)
            end
    elseif ((kk==5) || (kk==6)) % GAUS2
            k=kk-4;
            tau_k=tau(kk);
            pre_g_k=zeros(M,length(t));
            for index=1:length(t) % t=0:T:total_time
                for n=1:M
                    pre_g_k(n,index)=osci_magn(2,n)*exp(i*2*pi*(fn(n,1)*((index-1)*T)-(fc+fn(n,1))*tau_k*10^(-7))); %tau_k???
                end
                g(kk,index)=sum(pre_g_k(:,index)); % 產生g_4(t)
            end
    end
end

r_complex=frac_power(1).*g(1,:)+frac_power(2).*g(2,:)+frac_power(3).*g(3,:)+frac_power(4).*g(4,:)+frac_power(5).*g(5,:)+frac_power(6).*g(6,:);
semilogy(t,abs(g(1,:)),'--',t,abs(g(4,:)),':',t,abs(g(5,:)),'.-');
xlabel('Time,t/T'); 
ylabel('Envelope level (dB)');

%*** Fading gain distribution ***%
r=abs(r_complex);
figure(1);
hist(10*log10(r),500);
xlabel('Power (dB)'); 
ylabel('Number of pots');
title('Fading gain distribution');

%*** Time-domain strength profile ***%
figure(2);
semilogy(t,10*log10(r));
xlabel('Time,t/T'); 
ylabel('Envelope level (dB)');
title('Time-domain strength profile');

%*** Time-domain Autocorration ***%
total_tau=200;
Rrr=autocorr(r_complex,total_tau);
fm_tau=fm*total_tau;
x1 = linspace(0,fm_tau,total_tau+1);
figure(3);
plot(x1,real(Rrr));
xlabel('Time delay f_m\tau (sec)');
ylabel('Autocorrelation');
title('Time-domain autocorrelation');

%*** Doppler Spectrum ***%
NFFT = 2^12;
Srr = fft(Rrr,NFFT);
abs_Srr=abs(Srr);
f = 1/(2*T)*linspace(0,1,NFFT/2);
figure(4);
plot(f./fm,abs(Srr(1:NFFT/2)));
xlim([0 1]);
xlabel('Normalized Doppler frequency f/f_m ');
ylabel('S(f)');
title('Doppler Spectrum');

%*** Freq-domain strength profile ***%
NFFT=2^15;
r_freq=fft(r_complex,NFFT);
abs_r_freq=abs(r_freq);
f = 1/(2*T)*linspace(0,1,NFFT/2);
figure(5);
plot(f./fm,abs_r_freq(1:NFFT/2));
xlim([0 1]);
xlabel('frequency,f/f_m'); 
ylabel('Envelope level (dB)');
title('Frequency-domain strength profile');

%*** Freq-domain Autocorration ***%
R_r_freq=autocorr(r_freq,total_tau);
figure(6);
tau_f=0:1/(length(R_r_freq)-1):1;
tau_f=0:length(R_r_freq)-1;
tau_f=2*tau_f./T;
plot(tau_f,R_r_freq);
xlabel('Doppler frequency (Hz)');
ylabel('Autocorrelation');
title('Frequency-domain autocorrelation');

%*** Crossing rate and Fade durarion ***%
level_dB=-10:15; % dB
level=10.^(level_dB./10);
cross_rate=zeros(1,length(level));
fade_durarion=zeros(1,length(level));
n=0;
for kk=level
    cross_num=0;
    n=n+1;
    for index=1:length(r)-1
        if (r(1,index) < kk)&&(r(1,index+1) > kk)
            cross_num=cross_num+1;
        end
        if (r(1,index) < kk)&&(r(1,index+1) < kk)
            fade_durarion(1,n)=fade_durarion(1,n)+1;
        end
    end
    cross_rate(1,n)=cross_num/(length(r)-1);
end
figure(7);
semilogy(level_dB,cross_rate);
xlabel('Level (dB)');
ylabel('Level crossing rate');
title('Crossing rate');

figure(8);
plot(level_dB,fade_durarion.*T);
xlabel('Level (dB)');
ylabel('Envelope fade durarion (sec)');
title('Fade durarion');

%*** Cross-correlation ***%
Rg1g2=crosscorr(g(1,:),g(2,:),total_tau);
Rg1g4=crosscorr(g(1,:),g(4,:),total_tau);
Rg1g5=crosscorr(g(1,:),g(5,:),total_tau);
fm_tau=fm*total_tau;
figure(9);
x1 = linspace(0,fm_tau,(total_tau+1));
plot(x1,Rg1g2(1,total_tau+1:end),'g-',x1,Rg1g4(1,total_tau+1:end),'r--',x1,Rg1g5(1,total_tau+1:end),'b:');
xlabel('Time delay f_m\tau (sec)');
ylabel('Cross correlation');
title('Time-domain cross-correlation');

%*** Coherence time and Doppler spread ***%
temp=1;
for k=1:length(Rrr)  
    if(temp>=abs(Rrr(k)-0.9))
        coh=k;
        temp=abs(Rrr(k)-0.9);
    end
end
coh_time=coh*T; 
Doppler_spread=1/coh_time;  

%*** Coherence bendwidth ***%
temp=1;
for k=1:length(R_r_freq)  
    if(temp>=abs(R_r_freq(k)-0.5))
        coh=k;
        temp=abs(R_r_freq(k)-0.5);
    end
end
coh_BW=coh*(1/T); 
delay_spread=1/coh_BW;  

toc