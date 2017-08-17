#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import scipy.signal
import scipy.signal as signal


def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])


if __name__ == '__main__':
    # load and display image
    octopus = mpimg.imread('octopus_1.jpg')
    imgplot = plt.imshow(octopus)
    plt.show() # CTRL + w to close image once displayed


    # create kernel and convolve with image
    k = np.array([[0, 0, 0], [0, 1.125, 0], [0, 0, 0]]) - 0.125*np.ones((3,3))
    grayscale_octopus = rgb2gray(octopus)
    octopus_edges = signal.convolve2d(grayscale_octopus, k, 'same')

    
    # display image with edges
    imgplot_edges1 = plt.imshow(octopus_edges) # edges
    plt.show()
    
    imgplot_edges2 = plt.imshow(np.absolute(octopus_edges)) # edges w/ absolute color vals
    plt.show()
