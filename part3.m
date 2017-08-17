%% Part 3: Convolution to estimate voltage response to a spike train
clear all

% Generating a 20 Hz Poisson Spike Train.
target_rate = 20; % measured in Hz
N = 10000;
firingRate = 0;
p = 0;

% check if firing rate within threshold of target rate; threshold=0.1 difference
while 1
    if abs( firingRate - target_rate ) < 0.1
        break
        
    end

    % generate random spike train, where # above probability 
    % "fire" get firing rate and update probability; 
    % as time goes on, neuron more and more likely to fire.
    spikeTrain = rand( 1, N ) > ( 1 - p );
    firingRate = sum( spikeTrain == 1 ) / ( N / 1000 );
    p = p + 0.00001;

    % when we get p > 1, neuron did not fire in our time 
    % threshold
    if p > 1
        disp('did not find a suitable p')
        break
        
    end
    
end

% Construct kernel.
mu = 5; % in ms.
tKernel = -50 : 50;
k = exppdf( tKernel, mu ); 
plot( k )

% Perform convolution.
spikeTrain = double( spikeTrain );
estimatedVoltage = conv( spikeTrain, k, 'same' );

% Plot.
time = 1 : N; % time vector in ms
figure
hAx( 1 ) = subplot( 2, 1, 1 );
plot( time, estimatedVoltage )
ylim( [ 0 0.3 ] )
box off
ylabel( 'voltage (a.u.)' )

hAx( 2 ) = subplot( 2, 1, 2 );
plot( time, spikeTrain )
xlabel( 'time (ms)' )
ylabel( 'spikes' )
box off
ylim( [ 0 1.2 ] )
linkaxes( hAx, 'x' )
xlim( [ 0 1000 ] )