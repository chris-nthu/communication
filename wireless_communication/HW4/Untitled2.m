clear all;
n = 200000;
L = 4;
rayleigh_fading = sqrt(normrnd(0,1,[L, n]).*normrnd(0,1,[L, n])+j.*normrnd(0,1,[L, n]).*normrnd(0,1,[L, n]));

s = randn(L,n);