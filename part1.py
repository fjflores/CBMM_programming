#!/usr/bin/env python

import numpy as np

# part 1

# define dimensions
M = 10
N = 50

# define weight matrix
W = np.rand()
W = 2*(W-0.5)

# TODO check dimensions
x = np.rand(50)

y = W*x
