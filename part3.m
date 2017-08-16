%% Part 3: Convolution to estimate voltage response to a spike train
clear all
% generating a 20Hz Poisson Spike Train
target_rate = 20; % measured in Hz
N = 10000;
firing_rate = 0;
p = 0;
while 1
    if abs(firing_rate - target_rate)<0.1
        break
    end
    spiketrain = rand(1,N)>(1-p);
    firing_rate = sum(spiketrain==1)/(N/1000);
    p = p + 0.00001;
    if p > 1
        disp('did not find a suitable p')
        break
    end
end

% construct kernel
mu = 5;
k = exppdf(-50:50, mu); 
plot(k)

% convolution
spiketrain = double(spiketrain);
estimated_voltage = conv(spiketrain,k,'same');

% plot
time = (1:N); % time vector in ms
figure()
subplot(2,1,1)
plot(time,estimated_voltage)
ylabel('voltage (arb. units)')
subplot(2,1,2)
plot(time,spiketrain)
xlabel('time (ms)')
ylabel('spikes')
xlim([0 1000])
linkaxes()