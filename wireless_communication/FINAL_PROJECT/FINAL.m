clc; clear all; close all;

fm=120;
M=16;
T=0.01;
s=30000;
t=0:0.001:30;
H=hadamard(M);
p=sqrt([0.189 0.379 0.239 0.095 0.061 0.037]);
CLASS=zeros(3,30000);
GAUS1=zeros(1,30000);
GAUS2=zeros(2,30000);
CLASS1=zeros(3,30000);
GAUS11=zeros(1,30000);
GAUS21=zeros(2,30000);
NORMALPOWER=zeros(1,6);

for tap=1:3;
    for i=1:s;
        for m=1:16;
            b=pi*m/17;
            r=2*pi*(tap-1)*m/17;
            fun1=b+r;
            fun2=2*pi*m/(2*(2*16+1));            
            fun3=2^(3/2)*H(tap,m)*(cos(b)+j*sin(b))*cos(2*pi*fm*T*cos(fun2)*t(1,i)+fun1);
            CLASS(tap,i)=fun3+CLASS(tap,i);
        end
    end
    g=sqrt(mean(CLASS(tap,:).*conj(CLASS(tap,:))));
    CLASS1(tap,:)=(CLASS(tap,:)/g)*p(tap);
    NORMALPOWER(tap)=mean(CLASS1(tap,:).*conj(CLASS1(tap,:)));
end

ACCLASS=autocorr(CLASS(2,:),4999);
figure;plot(ACCLASS);         
title('Autocorrelation-CLASS');
GCLASS=log10(abs(CLASS(2,:)));
figure;plot(GCLASS);  
title('Time-domain Fading Gain-CLASS');
PSDCLASS=fft([ACCLASS(1:3000),zeros(1,4999-3000)],4999);   
figure;plot(linspace(-1,1,length(PSDCLASS)),abs(PSDCLASS));  
title('Power Spectral Density-CLASS');

x=linspace(-1,1,16);
x(2:end-1) = x(2:end-1)+x(2:end-1).*unifrnd(-1,1,1,14)*1e-2;
A1=6.649*exp(-0.5*(x+0.8).^2/(0.05^2));
A2=0.6649*exp(-0.5*(x-0.4).^2/(0.1^2));
B1=A1+A2;

tap=4;
for i=1:s;
    for m=1:16;
        fun4=sqrt(B1(m))*exp(j*(2*pi*fm*x(m)*(t(i)+300)));
        GAUS1(1,i)=fun4+GAUS1(1,i);
    end
    g=sqrt(mean(GAUS1(1,:).*conj(GAUS1(1,:))));
    GAUS11(1,:)=(GAUS1(1,:)/g)*p(tap);
    NORMALPOWER(tap)=mean(GAUS11(1,:).*conj(GAUS11(1,:)));
end

ACGAUS1=autocorr(GAUS1(1,:),1499);   
figure;plot(ACGAUS1(1:40));                
title('Autocorrelation-GAUS1');
GGAUS1=log10(abs(GAUS1(1,:)));
figure;plot(GGAUS1);         
title('Time-domain Fading Gain-GAUS1');
PSDGAUS1=fft([ACGAUS1(1:35),zeros(1,1500-35)],1500);    
figure;plot(linspace(-4,4,length(PSDGAUS1)),abs(fftshift(PSDGAUS1))); 
title('Power Spectral Density-GAUS1');

x=linspace(-1,1,16);
x(2:end-1) = x(2:end-1)+x(2:end-1).*unifrnd(-1,1,1,14)*1e-2;
A1=3.8*exp(-0.5*(x-0.7).^2/(0.1^2));
A2=(3.8/(10^1.5))*exp(-0.5*(x+0.4).^2/(0.15^2));
B2=A1+A2;
del=[0 30];

for tap=5:6;
    for i=1:s;
        for m=1:16;
            fun5=sqrt(B2(m))*exp(j*(2*pi*fm*x(m)*(t(i)+del(tap-4))));
            GAUS2(tap-4,i)=fun5+GAUS2(tap-4,i);
        end
    end
    g=sqrt(mean(GAUS2(tap-4,:).*conj(GAUS2(tap-4,:))));
    GAUS21(tap-4,:)=(GAUS2(tap-4,:)/g)*p(tap);
    NORMALPOWER(tap)=mean(GAUS21(tap-4,:).*conj(GAUS21(tap-4,:)));
end

ACGAUS2=autocorr(GAUS2(2,:),2099);  
figure;plot(ACGAUS2(1:40));                
title('Autocorrelation-GAUS2');
GGAUS2=log10(abs(GAUS2(2,:)));
figure;plot(GGAUS2);             
title('Time-domain Fading Gain-GAUS2');
PSDGAUS2=fft([ACGAUS2(1:35),zeros(1,2100-35)],2100);       
figure;plot(linspace(-4,4,length(PSDGAUS2)),abs(fftshift(PSDGAUS2))); 
title('Power Spectral Density-GAUS2');

d=[0 0.2 0.5 1.6 2.3 5];
i=1:6;
figure;stem(d(i),NORMALPOWER(i));
title('Typical Urban(TU)(6-rays)');