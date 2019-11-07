clc; clear;

% arguments
alpha = 0;
G = 0:0.001:8;

% compute throuphput
pure_aloha = G .* exp(-2*G);
slotted_aloha = G .* exp(-G);
unslotted_1p_csma = (G .* (1 + G + (alpha * G) .* (1 + G + (alpha*G/2))) .* exp(-G*(1+2*alpha))) ./ (G*(1+2*alpha) - (1-exp(-alpha*G)) + (1+alpha*G).*exp(-G*(1+alpha)));
slotted_1p_csma = (G .* (1 + alpha - exp(-alpha*G)) .* exp(-G*(1+alpha))) ./ ((1+alpha) * (1-exp(-alpha*G)) + alpha*exp(-G*(1+alpha)));
unslotted_nonp_csma = (G .* exp(-alpha*G)) ./ (G*(1+2*alpha) + exp(-alpha*G));
slotted_nonp_csma = (alpha * G .* exp(-alpha*G)) ./ (1 - exp(-alpha*G) + alpha);

% sketch figure
plot(G, pure_aloha, G, slotted_aloha, G, unslotted_1p_csma, G, slotted_1p_csma, G, unslotted_nonp_csma, G, slotted_nonp_csma, 'LineWidth', 3);
title('Throughput (alpha=0)'); xlabel('Traffic Load G'); ylabel('S: Throughput');
legend('Pure aloha', 'Slotted aloha', 'Unslotted 1-persistent CSMA', 'Slotted 1-persistent CSMA', 'Unslotted nonpersistent CSMA', 'Slotted nonpersistent CSMA');
grid on;
