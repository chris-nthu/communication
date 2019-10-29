clc; clear;

% Generate a 8x8 matrix	of Walsh codes (W)
W = 0;
for i=1:(4-1)
    W = [W, W; W, ~W];
end



