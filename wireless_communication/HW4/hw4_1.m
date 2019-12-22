clear all; clc;

Pb = zeros(4,9,4); % bit error rate
n = 10^6; % the number of input bits
QPSKrandSignal = sign(randn(1,n)); % random QPSK random signal -1 and 1
SNR = 1:9; % Es/No (dB)

for L = 1:4 % L is diversity branches
    r = zeros(L,n); % the received complex envelopes of the diversity branches
    
    for i = 1:9 % i is SNR Es/No
        rayleigh_fading = (1/sqrt(2))*(randn(L,n)+j*randn(L,n)); % complex rayleigh fading gain
        noise = sqrt((1/(10^(i/10)))*0.5)*(randn(L,n)+j*randn(L,n)); % received noise
        
        for k = 1:L
            r(k,:) = QPSKrandSignal.*(rayleigh_fading(k,:))+noise(k,:); % received complex signal
            r_gain(k,:) = abs(r(k,:)); % The length of received complex signal
        end
        
        %-----  SC  ------%
        if L == 1
            rd = (r./exp(j*angle(rayleigh_fading)));
        else
            [u,v] = max(r_gain);
            rd = sum((sparse(v,[1:n],1)).*r)./exp(j*angle(sum((sparse(v,[1:n],1)).*rayleigh_fading)));
        end
        rd = sign(real(rd));
        Pb(1,i,L) = sum(rd~=QPSKrandSignal)/n; % Compare with origin transmitted signal to calculate bit error rate
        %-----------------%
        
        %-----  MRC  -----%
        if L == 1
            rd = r.*conj(rayleigh_fading);
        else
            rd = sum(r.*conj(rayleigh_fading));
        end   
        rd = sign(real(rd));
        Pb(2,i,L) = sum(rd~=QPSKrandSignal)/n; % Compare with origin transmitted signal to calculate bit error rate
        %-----------------%
        
        %-----  EGC  -----%
        if L == 1
            rd = (r./exp(j*angle(rayleigh_fading)));
        else
            rd = sum(r./exp(j*angle(rayleigh_fading)));
        end   
        rd = sign(real(rd));
        Pb(3,i,L) = sum(rd~=QPSKrandSignal)/n; % Compare with origin transmitted signal to calculate bit error rate
        %-----------------%
        
        %-----  DC  ------%
        if L == 1
            rd = (r);
        else
            rd = sum(r);
        end  
        rd = sign(real(rd));
        Pb(4,i,L) = sum(rd~=QPSKrandSignal)/n; % Compare with origin transmitted signal to calculate bit error rate
        %-----------------%
    end
end

figure('name','QPSK Selective Combining (Rayleigh)');
semilogy(SNR,Pb(1,:,1),SNR,Pb(1,:,2),SNR,Pb(1,:,3),SNR,Pb(1,:,4));
title('QPSK Selective Combining (Rayleigh)');
xlabel('SNR(dB)');ylabel('P_b');
legend('L=1','L=2','L=3','L=4');ylim([10^-4 10^0]);
saveas(gcf,'Result\QPSK Selective Combining (Rayleigh).jpg');

figure('name','QPSK Maximal Ratio Combining (Rayleigh)');
semilogy(SNR,Pb(2,:,1),SNR,Pb(2,:,2),SNR,Pb(2,:,3),SNR,Pb(2,:,4));
title('QPSK Maximal Ratio Combining (Rayleigh)');
xlabel('SNR(dB)');ylabel('P_b');
legend('L=1','L=2','L=3','L=4');ylim([10^-4 10^0]);
saveas(gcf,'Result\QPSK Maximal Ratio Combining (Rayleigh).jpg');

figure('name','QPSK Equal Gain Combining (Rayleigh)');
semilogy(SNR,Pb(3,:,1),SNR,Pb(3,:,2),SNR,Pb(3,:,3),SNR,Pb(3,:,4));
title('QPSK Equal Gain Combining (Rayleigh)');
xlabel('SNR(dB)');ylabel('P_b');
legend('L=1','L=2','L=3','L=4');ylim([10^-4 10^0]);
saveas(gcf,'Result\QPSK Equal Gain Combining (Rayleigh).jpg');

figure('name','QPSK Direct Combining (Rayleigh)');
semilogy(SNR,Pb(4,:,1),SNR,Pb(4,:,2),SNR,Pb(4,:,3),SNR,Pb(4,:,4));
title('QPSK Direct Combining (Rayleigh)');
xlabel('SNR(dB)');ylabel('P_b');
legend('L=1','L=2','L=3','L=4');ylim([10^-4 10^0]);
saveas(gcf,'Result\QPSK Direct Combining (Rayleigh).jpg');
