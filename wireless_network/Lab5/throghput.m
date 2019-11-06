clc; clear;

G = 0:0.01:8;
slotted = G .* exp(-G);
pure = G .* exp(-2*G);

plot(G, slotted);
hold on;
plot(G, pure);
