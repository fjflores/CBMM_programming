#!/usr/bin/env python

import numpy as np # this package is used for most mathematical operations
import matplotlib.pyplot as plt

# define input/output dimensions
M = 10
N = 50

# define weight matrix
W = np.random.rand(M,N)
W = 2*(W-0.5)

# TODO check dimensions
x = np.random.rand(50) # random is the numpy package used to generate random numbers

y = W*x
