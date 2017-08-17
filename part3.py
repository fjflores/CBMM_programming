#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import expon

# generate 20Hz Poisson spike train
target_rate = 20
N = 10000
firing_rate = 0
p = 0

while True:
    # check if firing rate within threshold of target rate; threshold=0.1 difference
    if abs(firing_rate - target_rate) < 0.1:
        break

    # generate random spike train, where # above probability "fire"
    # get firing rate and update probability; as time goes on, neuron more and more likely to fire
    spike_train = np.random.rand(1,N) > (1-p)
    firing_rate = np.sum(spike_train==1) / (N/1000)
    p = p + 0.0001

    # when we get p > 1, neuron did not fire in our time threshold
    if p > 1:
        print 'Did not find a suitable p'
        break

# construct kernel
mu = 5
k  = expon.pdf( range(-50, 50), mu) # exponential kernel
plt.plot(k)
plt.title('kernel')
# plt.show() # uncomment to display plot
# TODO label axes + title

# convolution
spike_train = spike_train.astype(float).transpose().flatten() # convert to float & flatten to vector
estimated_voltage = np.convolve(spike_train, k, 'same')

# plot
time = range(0,N)
plt.subplot(2,1,1)
plt.plot(time, estimated_voltage)
plt.ylabel('voltage (arbitrary units)')


plt.subplot(2,1,2)
plt.plot(time, spike_train)
plt.show()
plt.xlabel('time (ms)')
plt.ylabel('spikes')
plt.xlimit(0, 1000)
