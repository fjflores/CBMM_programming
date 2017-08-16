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
    if abs(firing_rate - target_rate) < 0.1:
        break

    spike_train = np.random.rand(1,N) > (1-p)
    firing_rate = np.sum(spike_train==1) / (N/1000)
    p = p + 0.0001

    if p > 1:
        print 'Did not find a suitable p'
        break

# construct kernel
mu = 5
k  = expon.pdf( range(-50, 50), mu)
plt.plot(k)
# plt.show() # uncomment to display plot
# TODO label axes + title

# convolution
spike_train = spike_train.astype(float)
estimated_voltage = np.convolve(spike_train, k, 'same')
exit()

# plot
#time = #INCREMENT
plt.subplot(2,1,1)
plot(time, estimated_voltage)

