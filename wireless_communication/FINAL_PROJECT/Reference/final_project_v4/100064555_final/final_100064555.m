clear all;
M=16;
t_0=0;

x_t=ones(1,20000);     %input sequence
T_s=0.2E-6;            %Sample rate 5MHz
f_max=50000;           %fmT =0.01 ; max dop frequence = 50kHz

%COST 207
a_l=[0.5,1,0.63,0.25,0.16,0.1];             % path gain
tau_l=[0,0.2,0.6,1.6,2.4,5]*1E-6;           % delay 
DOPP_KAT=['CL';'CL';'G1';'G1';'G2';'G2'];   % doppler spectrum
num_of_taps=length(DOPP_KAT);               % tap 
F1=zeros(num_of_taps,M+2*num_of_taps-1);
F2=F1;C1=F1;C2=F1;TH1=F1;TH2=F1;
F01=zeros(1,num_of_taps);F02=F01;
RHO=zeros(1,num_of_taps);F_RHO=RHO;
NN1=M+2*(num_of_taps-1):-2:M;

for k=1:num_of_taps
    [f1,f2,c1,c2,th1,th2,rho,f_rho,f01,f02]=dop_spec(DOPP_KAT(k,:),NN1(k));
    F1(k,1:NN1(k))=f1;
    C1(k,1:NN1(k))=c1*sqrt(a_l(k));
    TH1(k,1:NN1(k))=th1;
    F2(k,1:NN1(k)+1)=f2;
    C2(k,1:NN1(k)+1)=c2*sqrt(a_l(k));
    TH2(k,1:NN1(k)+1)=th2;
    F01(k)=f01;F02(k)=f02;
    RHO(k)=rho;F_RHO(k)=f_rho;
end
% Determine indices of the delay elements of the FIR filter:
q_l=tau_l/T_s+1;
% Initialization of the delay elements of the FIR filter:
T=zeros(1,max(q_l));

% output sequence y_t
y_t=zeros(size(x_t));

for n=0:length(x_t)-1,
    mu_l=sum((C1.*cos(2*pi*F1*f_max*(n*T_s+t_0)+TH1)).').*exp(-1j*2*pi*F01*f_max*(n*T_s+t_0))+1j*(sum((C2.*cos(2*pi*F2*f_max*(n*T_s+t_0)+TH2)).').*exp(-1j*2*pi*F02*f_max*(n*T_s+t_0)))+RHO.*exp(1j*2*pi*F_RHO*f_max*(n*T_s+t_0));
    CL(n+1)=sum(mu_l(1));
    G1(n+1)=sum(mu_l(3));
    G2(n+1)=sum(mu_l(5));
    T(1)=x_t(n+1);
    y_t(n+1)=sum(mu_l.*T(q_l));%
    T(2:length(T))=T(1:length(T)-1);
end

t_0=length(x_t)*T_s+t_0;
Fja=fft(CL(1:10000));
Fg1=fft(G1(1:10000));
Fg2=fft(G2(1:10000));
Sja=abs(Fja.*conj(Fja));
Sg1=abs(Fg1.*conj(Fg1));
Sg2=abs(Fg2.*conj(Fg2));

ff=linspace(-1,1,201);

figure
plot(ff,[ abs(Sja(9901:10000)) abs(Sja(1:101))], 'linewidth', 1);
title('CLASS Doppler Spectrum');
xlabel('Normalize Frequence f/fm');
ylabel('Power');
title('CLASS Doppler Spectrum');

figure
plot(ff,[ abs(Sg1(9901:10000)) abs(Sg1(1:101))],'linewidth', 1);
xlabel('Normalize Frequence f/fm')
ylabel('Power')
title('GAUSS1 Doppler Spectrum')

figure(9)
plot(ff,[ abs(Sg2(9901:10000)) abs(Sg2(1:101))],'linewidth', 1);
xlabel('Normalize Frequence f/fm');
ylabel('Power');
title('GAUSS2 Doppler Spectrum');


