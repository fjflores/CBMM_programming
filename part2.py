#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

def generateVoltage(p, T, V_reset, V_thresh, V_0):
    V = np.zeros((T)) # double parenthesis because the arg is the tuple (1,T) and can be followed by other arguments
    V[0] = V_0

    for t in range(0, T-1):
        if V[t] == V_thresh:
            V[t+1] = V_reset
        else:
            dV = ( (np.random.normal(0, 1) < p) - 0.5) * 2
            V[t+1] = V[t] + dV

        if V[t+1] > V_thresh:
            V[t+1] = V_thresh
    return V


# main function
if __name__ == '__main__':
    T = 10000
    V_reset = -70
    V_thresh = -45
    V_0 = -65

    # find p such that firing rate is approx 10Hz
    firing_rate = 0
    p = 0

    while True:
        if abs(firing_rate - 10) < 0.1:
            break

        V = generateVoltage(p, T, V_reset, V_thresh, V_0)
        firing_rate = np.sum(V==V_thresh) / (T/1000)
        p = p + 0.0001
        print p

        if p > 1:
            print 'did not find a suitable p'
            break

    # plot
    time = range(0, T)
    plt.plot(time,V)
    plt.xlabel=('time (ms)')
    plt.ylabel('voltage (mV)')
    plt.show()
