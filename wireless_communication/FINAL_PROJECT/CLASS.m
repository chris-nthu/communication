%% Channel with CLASS Doppler Spectrum
function [g_delay] = CLASS(Ak, Power, Delay, M, fm, T, NumSamples)
    % Ak:           Hadamard matrix of k-th tap
    % Power:        channel power
    % Delay:        the delay of tap
    % M:            numbers of oscillator
    % fm:           maximum doppler shift
    % T:            sampling duration
    % NumSamples:   total sample points
    
    %% parameter configurations
    N = 2*(2*M+1);
    n = 1:1:M;
    beta_n = (pi.*n)/M;
    alpha = 0;
    theta = (2*pi.*n)/N; % uniform incoming direction
    
    gI = zeros(NumSamples, 1);
    gQ = zeros(NumSamples, 1);

    %% Sum of Sinusoids Method
    for k = 0:(NumSamples-1)
        gI(k+1) = sqrt(2)*(2*sum(Ak .* (cos(beta_n).*cos(2*pi*fm*T*k.*cos(theta)))) + sqrt(2)*cos(alpha)*cos(2*pi*fm*T*k)); %inphase
        gQ(k+1) = sqrt(2)*(2*sum(Ak .* (sin(beta_n).*cos(2*pi*fm*T*k.*cos(theta)))) + sqrt(2)*sin(alpha)*cos(2*pi*fm*T*k)); %quadrature
    end
    
    g = gI + 1i*gQ;
    
    g(1:100) = []; % remove the initial terms
    NumSamples = NumSamples - 100;

    g = sqrt(Power/mean(g.*conj(g))) .* g ;
    g_delay = [zeros(floor(Delay),1); g];
    
    if(length(g_delay) > NumSamples)
        g_delay(NumSamples+1:end) = []; 
    end
end