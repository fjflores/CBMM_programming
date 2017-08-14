%% Part 1: Matrix Operations for a Feedforward Network
clear all
M = 10;
N = 50;

W = rand(M,N);
W = 2.*(W - 0.5);

x = randn(1,50)';

y = W*x;

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


%% Part 4: Convolution to detect edges in images
clear all
load('octopus.mat')

figure()
imagesc(octopus);
colormap(gray);

k = [ 0,0,0 ; 0,1.125,0 ; 0,0,0 ] - 0.125*ones(3,3);
k=double(k);
octopusedges = conv2(octopus,k,'same');

figure()
imagesc(octopusedges);
colormap(gray);

image = abs(octopusedges);

figure()
imagesc(image);
colormap(gray);

%% Part 5: Correlation to analyze premotor neural data
clear all
load('MackeviciusData.mat')

T = length(song)/fs;
dt = 1/fs;
k = length(song);
time = [dt:dt:T];

figure()
subplot(2,1,1)
plot(time,song)
subplot(2,1,2)
plot(time,units)

%sound(song,fs)

smoothunits = log(conv(units.^2, gausswin(ceil(fs*0.026)), 'same'));
smoothsong = log(conv(song.^2, gausswin(ceil(fs*0.026)), 'same'));

figure()
subplot(2,1,1)
plot(time,smoothsong)
subplot(2,1,2)
plot(time,smoothunits)

songunits = xcorr(smoothunits,smoothsong);

time2 = (1:length(songunits)).*dt - 0.5*length(songunits)*dt;
figure()
plot(time2,songunits)
xlim([-0.5 0.5])

%% Part 6: Singular Value Decomposition (SVD) on images of faces
clear all; close all
load('jaffe.mat')

% i=1;
% figure()
% imagesc(reshape(IMS(i,:),137,86));
% colormap gray;

mean_of_images = mean(IMS,2);
IMS = IMS - repmat(mean_of_images,1,size(IMS,2));
for i=1:size(IMS,1)
    IMS(i,:) = IMS(i,:)./var(IMS(i,:));
end
[U,S,V] = svd(IMS);

% confirm IMS = U*S*V'

figure()
plot(diag(S))
xlabel('ranking singular value label')
ylabel('singular value')

figure()
for i=1:9
    subplot(3,3,i)
    imagesc(reshape(V(:,i),137,86));
    title(['singular value ',num2str(i)])
end

n = 9;
V_dim_red = V;
for i=(n+1):size(V,2)
    V_dim_red(:,i) = 0;
end
I = U*S*V_dim_red';

num_images = 5;
figure()
count=1;
for j = 1:num_images
    subplot(num_images,2,count)
    count=count+1;
    imagesc(reshape(IMS(j,:),137,86));
    subplot(num_images,2,count)
    count=count+1;
    imagesc(reshape(I(j,:),137,86));
end

%% Part 7: Estimation of spectro-temporal receptive fields with spike-triggered averaging
clear all; close all
generateStimulus

freq = logspace(2,4,50);% 50 log-spaced freqs 100-10000Hz
dt=0.01;% sampling interval in seconds
%PlayStim(Stimulus(:,1:(3/dt)),freq, dt);% play first 3s

generateKernel
%PlayStim(Kernel, freq, 0.001)

estimated_response = zeros(1,size(Stimulus,2));
for i=size(Kernel,2)+1:size(Stimulus,2)
    response = Kernel.*Stimulus(:,i-size(Kernel,2):i-1);
    estimated_response(i) = sum(response(:));
end
sorted_est_resp = flip(sort(estimated_response));
thresh = sorted_est_resp(10000);
spikes = (estimated_response>=thresh);
spikes = double(spikes);

figure()
subplot(3,1,1)
imagesc(Stimulus(:,1:(5/dt)))
subplot(3,1,2)
plot(estimated_response(1:(5/dt)))
subplot(3,1,3)
plot(spikes(1:(5/dt)))

% Find STA
STA = zeros(50,150);
for i=find(spikes==1)
    STA = STA + (1/sum(spikes)).*Stimulus(:,i-150:i-1);
end
    
figure()
surf(1:150,logspace(2,4,50),STA,'edgecolor','none'); axis tight;
view(0,90);shg
set(gca, 'fontsize', 16)
set(gca, 'yscale', 'log')
xlabel('time(msec)', 'fontsize', 20)
ylabel('Frequency (Hz)','fontsize', 20 )
title('STA')
colorbar;

figure()
imagesc(Kernel)
title('Kernel (STRF)')

%PlayStim(STA, freq, 0.001)
%%















