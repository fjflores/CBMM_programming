
%% Part 2: Logical operations, for-loops, and plotting (random walk)
clear all
T = 10000; % measured in ms
Vreset = -70; % measured in mV
Vthresh = -45; % measured in mV
V0 = -65; % measured in mV

% find p such that the firing rate is approximately 10Hz
firing_rate = 0;
p = 0;
while 1
    if abs(firing_rate - 10)<0.1
        break
    end
    V = GenerateVoltage(p,T,Vreset,Vthresh,V0);
    firing_rate = sum(V==Vthresh)/(T/1000);
    p = p + 0.0001;
    if p > 1
        disp('did not find a suitable p')
        break
    end
end

time = (1:T); % time vector in ms

figure()
plot(time,V)
xlabel('time (ms)')
ylabel('voltage (mV)')
xlim([0 1000])
title(['probability that dV =1 is ',num2str(p)])