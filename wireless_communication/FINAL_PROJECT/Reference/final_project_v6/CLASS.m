function [ g_delay ] = CLASS(Ak, Power, Delay, M, fm,T, NumSamples)
% Channel with CLASS Doppler spectrum
% Power: channel power
% Ak: Hardamard codes of k-th tap
% Delay: the delay of tap
% M: number of frequency oscillators
% fm: maximum doppler shift 
% T: sampling duration
% NumSamples: total sample points
%% Parameter Setting

N = 4*M + 2;
n = 1:1:M;
beta = (pi/M) .* n;
alpha = 0;
theta = (2*pi/N) .* n; % uniform incoming direction

gI = zeros(NumSamples, 1);
gQ = zeros(NumSamples, 1);

%% Sum of Sinusoids Method
for k = 0 : NumSamples-1,
    gI(k+1) =  sqrt(2)*(2*sum(Ak .* (cos(beta).*cos(2*pi*fm*T*k.*cos(theta)))) + sqrt(2)*cos(alpha)*cos(2*pi*fm*T*k)); %inphase
    gQ(k+1) =  sqrt(2)*(2*sum(Ak .* (sin(beta).*cos(2*pi*fm*T*k.*cos(theta)))) + sqrt(2)*sin(alpha)*cos(2*pi*fm*T*k)); %quadrature    
end;

g = gI + gQ.*1i;

g(1:100) = []; % remove the initial terms
NumSamples = NumSamples - 100;

g = sqrt(Power/mean(g.*conj(g))) .* g ;
g_delay = [zeros(floor(Delay),1); g];
if(length(g_delay) > NumSamples), g_delay(NumSamples+1:end) = []; end;

end

