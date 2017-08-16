%% Part 1: Matrix Operations for a Feedforward Network
clear all
M = 10;
N = 50;

W = rand(M,N);
W = 2.*(W - 0.5);

x = randn(1,50)';

y = W*x;