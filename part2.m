%% Part 2: Logical operations, for-loops, and plotting (random walk)
clear all

% Number of timesteps to simulate (in ms).
T = 10000;

% Set voltage to reset (in mV)
Vreset = -70;

% Set threshold voltage (in mV).
Vthresh = -45;

% Set initial voltage (in mV).
V0 = -65;

% Find p such that the firing rate is approximately 10Hz.
% This procedure involves computing the empirical cdf 
% by simulation.
firingRate = 0;
p = 0;
while 1
    if abs( firingRate - 10 ) < 0.1
        break
        
    end
    
    V = generatevoltage( p, T, Vreset, Vthresh, V0 );
    firingRate = sum( V == Vthresh ) / ( T / 1000 );
    p = p + 0.0001;
    
    if p > 1
        disp( 'did not find a suitable p' )
        break
        
    end
    
end

% Create time vector from 1 to T (in ms).
time = 1 : T; 

% Plot the results.
figure
plot( time, V )
xlabel( 'time (ms)' )
ylabel( 'voltage (mV)' )
xlim( [ 0 1000 ] )
title( [ 'probability that dV =1 is ', num2str( p ) ] )
