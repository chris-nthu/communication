% CDMA Simulation for N Transmitter/Receiver Pairs
 
 
% data bit stream for each sender
D = [  1 -1  1 -1  1  1 -1 -1 ; 
      -1 -1  1  1  1 -1 -1  1 ;
       1  1 -1 -1 -1  1  1 -1 ;
       1  1  1  1 -1 -1 -1 -1 ];
 
 
% unique code for each sender (determined using the Walsh Set)
C = [ -1 -1 -1 -1 ;
      -1  1 -1  1 ;
      -1 -1  1  1 ;
      -1  1  1 -1 ];
 
 
% parameters
M = length(C);       % length (number of bits) of code
Y = size(D);              
N = Y(1);            % number of unique senders / bit streams
I = Y(2);            % number of bits per stream
T = [];              % sum of all transmitted and encoded data on channel
RECON = [];          % vector of reconstructed bits at receiver
 
 
% show data bits and codes
'Vector of data bits to be transmitted:', D
'Vector of codes used for transmission:', C
 
 
% encode bits and transmit
G = zeros(I,M);
for n = 1:N
    Z = zeros(I,M);
    for i = 1:I
        for m = 1:M
            Z(i,m) = [D(n,i)*C(n,m)];        
        end
    end
    G = G + Z;
end
 % show channel traffic
for i = 1:I
    T = [ T G(i,:) ];
end
'Resulting traffic on the channel:', T
 
 
% decode and reconstruct
for n = 1:N
    TOT = zeros(1,I);
    R   = zeros(I,M);
    for i = 1:I
        for m = 1:M
            R(i,m) = G(i,m) * C (n,m);
            TOT(i) = TOT(i) + R (i,m);
         end
    end
    RECON = [RECON ; TOT / M];
end
'Reconstructed data at the receiver:'
RECON