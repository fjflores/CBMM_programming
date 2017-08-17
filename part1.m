%% Part 1: Matrix Operations for a Feedforward Network
clear all

% M is the number of rows, and N is the number of columns.
M = 10;
N = 50;

% Generate a random number between 0 and 1, drawed from a uniform 
% distribution.
W = rand( M, N );

% Map the numbers between [0,1] to numbers between [-1,1].
W = 2 .* ( W - 0.5 );

% Generate a column input vector x with 50 elements.
x = randn( 50, 1 );

% Compute the output of the network.
y = W * x;