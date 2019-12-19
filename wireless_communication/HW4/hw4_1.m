clear all; clc;

Pb = zeros(4,9,4); % bit error rate
n = 5*10^5; % the number of input bits
ranNum = sign(randn(1,n)); % random generate -1 or 1
SNR = 1:9;

for L = 1:4 % L is diversity branches
    r = zeros(L,n);
    
    for i = 1:9 % i is SNR Es/No
        rayleigh_fading = (1/sqrt(2))*(randn(L,n)+j*randn(L,n));
        noise = sqrt((1/(10^(i/10)))*0.5)*(randn(L,n)+j*randn(L,n));
        
        for k = 1:L
        r(k,:) = ranNum.*(rayleigh_fading(k,:))+noise(k,:);
        r_gain(k,:) = abs(r(k,:));
        end
        
        %-----  SC  ------%
        if L == 1
            rd = (r./exp(j*angle(rayleigh_fading)));
        else
            [u,v] = max(r_gain);
            rd = sum((sparse(v,[1:n],1)).*r)./exp(j*angle(sum((sparse(v,[1:n],1)).*rayleigh_fading)));
        end
        rd = sign(real(rd));
        Pb(1,i,L) = sum(rd~=ranNum)/n;
        %-----------------%
        
        %-----  MRC  -----%
        if L == 1
            rd = r.*conj(rayleigh_fading);
        else
            rd = sum(r.*conj(rayleigh_fading));
        end   
        rd = sign(real(rd));
        Pb(2,i,L) = sum(rd~=ranNum)/n;
        %-----------------%
        
        %-----  EGC  -----%
        if L == 1
            rd = (r./exp(j*angle(rayleigh_fading)));
        else
            rd = sum(r./exp(j*angle(rayleigh_fading)));
        end   
        rd = sign(real(rd));
        Pb(3,i,L) = sum(rd~=ranNum)/n;
        %-----------------%
        
        %-----  DC  ------%
        if L == 1
            rd = (r);
        else
            rd = sum(r);
        end  
        rd = sign(real(rd));
        Pb(4,i,L) = sum(rd~=ranNum)/n;
        %-----------------%
    end
end

figure(1);
semilogy(SNR,Pb(1,:,1),SNR,Pb(1,:,2),SNR,Pb(1,:,3),SNR,Pb(1,:,4));
title('Selective Combining (Rayleigh)');
xlabel('SNR(dB)');ylabel('P_b');
legend('L=1','L=2','L=3','L=4');ylim([10^-4 1]);

figure(2);
semilogy(SNR,Pb(2,:,1),SNR,Pb(2,:,2),SNR,Pb(2,:,3),SNR,Pb(2,:,4));
title('Maximal Ratio Combining (Rayleigh)');
xlabel('SNR(dB)');ylabel('P_b');
legend('L=1','L=2','L=3','L=4');ylim([10^-4 1]);

figure(3);
semilogy(SNR,Pb(3,:,1),SNR,Pb(3,:,2),SNR,Pb(3,:,3),SNR,Pb(3,:,4));
title('Equal Gain Combining (Rayleigh)');
xlabel('SNR(dB)');ylabel('P_b');
legend('L=1','L=2','L=3','L=4');ylim([10^-4 1]);

figure(4);
semilogy(SNR,Pb(4,:,1),SNR,Pb(4,:,2),SNR,Pb(4,:,3),SNR,Pb(4,:,4));
title('Direct Combining (Rayleigh)');
xlabel('SNR(dB)');ylabel('P_b');
legend('L=1','L=2','L=3','L=4');ylim([10^-4 1]);
