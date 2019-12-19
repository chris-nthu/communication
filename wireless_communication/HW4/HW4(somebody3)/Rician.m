clear all

% Pb=zeros(4,5,4);
K=1;
s=sqrt((2*1*K)/2);

for L=1:4
n=200000;
r=zeros(L,n);
  for i=1:9
    x_n=sign(randn(1,n));
    rician=((s+randn(L,n))+j*(s+randn(L,n)))/(sqrt(2+2*s^2));
    noise=sqrt((1/(10^(i/10)))*0.5)*(randn(L,n)+j*randn(L,n));
    for k=1:L
    r(k,:)=x_n.*(rician(k,:))+noise(k,:);
    r_gain(k,:)=(abs(r(k,:)));
    end
%% SC
    if L==1
        rd=r./exp(j*angle(rician));
    else
        [u,v]=max(r_gain);
        rd=sum((sparse(v,[1:n],1)).*r)./exp(j*angle(sum((sparse(v,[1:n],1)).*rician)));
    end
    rd=sign(real(rd));
    Pb(1,i,L)=sum(rd~=x_n)/n;
%% MRC
    if L==1
        rd=r.*conj(rician);
    else
        rd=sum(r.*conj(rician));
    end   
    rd=sign(real(rd));
    Pb(2,i,L)=sum(rd~=x_n)/n;
%% EGC
    if L==1
        rd=(r./exp(j*angle(rician)));
    else
        rd=sum(r./exp(j*angle(rician)));
    end   
    rd=sign(real(rd));
    Pb(3,i,L)=sum(rd~=x_n)/n;
%% DC
    if L==1
        rd=(r);
    else
        rd=sum(r);
    end  
     rd=sign(real(rd));
     Pb(4,i,L)=sum(rd~=x_n)/n;
   end
end
figure
semilogy(1:9,Pb(1,:,1),1:9,Pb(1,:,2),'-.',1:9,Pb(1,:,3),'--',1:9,Pb(1,:,4),':')
title('SC BER (Rician)');xlabel('SNR(dB)');ylabel('BER');legend('L=1','L=2','L=3','L=4');ylim([10^-4 1])

figure
semilogy(1:9,Pb(2,:,1),1:9,Pb(2,:,2),'-.',1:9,Pb(2,:,3),'--',1:9,Pb(2,:,4),':')
title('MRC BER (Rician)');xlabel('SNR(dB)');ylabel('BER');legend('L=1','L=2','L=3','L=4');ylim([10^-4 1])

figure;
semilogy(1:9,Pb(3,:,1),1:9,Pb(3,:,2),'-.',1:9,Pb(3,:,3),'--',1:9,Pb(3,:,4),':')
title('EGC BER (Rician)');xlabel('SNR(dB)');ylabel('BER');legend('L=1','L=2','L=3','L=4');ylim([10^-4 1])

figure;
semilogy(1:9,Pb(4,:,1),1:9,Pb(4,:,2),'-.',1:9,Pb(4,:,3),'--',1:9,Pb(4,:,4),':')
title('Direct Combining BER (Rician)');xlabel('SNR(dB)');ylabel('BER');legend('L=1','L=2','L=3','L=4');ylim([10^-4 1])

