clc; clear; close all;

M = 16;
t = 0:0.001:30;
T = 0.01;
s = 30000;
A = hadamard(M);
p = sqrt([0.189 0.379 0.239 0.095 0.061 0.037]);
fc = 2*10^9;                        % carrier frequency
c = 3*10^8;                         % light velocity
v = [50*1000/3600 90*1000/3600];    % MS velocity is 50km/hr and 90km/hr respectively
lambda = c / fc;                    % wavelength
fm = v / lambda;

CLASS = zeros(3,30000);
GAUS1 = zeros(1,30000);
GAUS2 = zeros(2,30000);
CLASS1 = zeros(3,30000);
GAUS11 = zeros(1,30000);
GAUS21 = zeros(2,30000);
NORMALPOWER = zeros(1,6);

for tap = 1:3
    for i = 1:s
        for n = 1:M
            beta = pi*n/(M+1);
            gamma = 2*pi*(tap-1)*n/(M+1);
            theta = beta + gamma;
            fn = fm(1)*cos(2*pi*n/(2*(2*M+1)));
            buf = 2*sqrt(2)*A(tap,n)*(cos(beta)+1i*sin(beta))*cos(2*pi*T*fn*t(1,i)+theta);
            CLASS(tap,i) = buf + CLASS(tap,i);
        end
    end
    g = sqrt(mean(CLASS(tap,:).*conj(CLASS(tap,:))));
    CLASS1(tap,:) = (CLASS(tap,:)/g)*p(tap);
    NORMALPOWER(tap) = mean(CLASS1(tap,:).*conj(CLASS1(tap,:)));
end


ACCLASS = autocorr(CLASS(2,:),4500);
x=linspace(0,4,4501);
figure; plot(x, ACCLASS);
title('Autocorrelation-CLASS');


% M = 16;
% N = (2*M+1) * 2;
% fc = 2*10^9;                        % carrier frequency
% c = 3*10^8;                         % light velocity
% v = [50*1000/3600 90*1000/3600];    % MS velocity is 50km/hr and 90km/hr respectively
% lambda = c / fc;                    % wavelength
% fm = v / lambda;
% t = (1:1:5000);                     % time (sec)
% A = hadamard(M);                    % M*M hadamard matrix
% 
% CLASS = zeros(3, 2, length(t));
% GAUS1 = zeros(1, 2, length(t));
% GAUS2 = zeros(2, 2, length(t));
% buffer = zeros (1, 2, length(t));
% 
% for tap = 1:3 % index of power delay profile
%     for i = 1:2
%         for n = 1:M
%             beta_n = (pi*n)/M;
%             theta = (2*pi*n)/N;
%             fn = cos(theta);
%             alpha = 0;
% 
%             buffer = sqrt(2)*(2*(A(tap, n)*cos(beta_n)*cos(2*pi*fn.*t)+sqrt(2)*cos(alpha)*cos(2*pi*fm(i).*t))) + 1i*2*(A(tap,n)*sin(beta_n)*cos(2*pi*fn.*t)+sqrt(2)*sin(alpha)*cos(2*pi*fm(i).*t));
%             for j = 1:length(t)
%                 CLASS(tap, i, j) = buffer(j) + CLASS(tap, i, j);
%             end
%         end
%     end
% end
% 
% AutoCorrelation_CLASS = autocorr(CLASS(1,1,:), 100);
% plot(AutoCorrelation_CLASS);

% fmT = [0.01, 0.1, 0.5];
% gi_1 = zeros(6, 5000);
% gq_1 = zeros(6, 5000);
% g = zeros(6, 5000);
% gi = zeros(6, 5000);
% gq = zeros(6, 5000);
% t = [1:1:5000];
% 
% for k=1:2
%     for i=1:3
%         for n=1:M(1,k)
%             gi_1(i+3*(k-1),:) = gi_1(i+3*(k-1),:) + cos(pi*n/M(1,k)) * cos(2*pi*fmT(1,i) * t * cos(2*pi*n/N(1,k)));
%             gq_1(i+3*(k-1),:) = gq_1(i+3*(k-1),:) + sin(pi*n/M(1,k)) * cos(2*pi*fmT(1,i) * t * cos(2*pi*n/N(1,k)));
%         end
%     end
% end
% 
% gi_1 = gi_1 * 2 * sqrt(2);
% gq_1 = gq_1 * 2 * sqrt(2);
% 
% for i=1:3
%     gi(i, :)     = gi_1(i, :) + 2 * cos(2*pi*fmT(1,i)*t);
%     gi(i+3, :)   = gi_1(i+3,:) + 2 * cos(2*pi*fmT(1,i)*t);
% end
% 
% gq = gq_1;
% 
% for i=1:6
%     g_db(i,:) = 10 * log10(sqrt(gi(i,:).^2+gq(i,:).^2));
%     g(i,:) = gi(i,:) + 1i * gq(i,:);
% end
% 
% g_autocorr1 = autocorr(g(1,:), 10/fmT(1,1));
% g_autocorr2 = autocorr(g(2,:), 10/fmT(1,2));
% g_autocorr3 = autocorr(g(3,:), 10/fmT(1,3));
% g_autocorr4 = autocorr(g(4,:), 10/fmT(1,1));
% g_autocorr5 = autocorr(g(5,:), 10/fmT(1,2));
% g_autocorr6 = autocorr(g(6,:), 10/fmT(1,3));