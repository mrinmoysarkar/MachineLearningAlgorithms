# -*- coding: utf-8 -*-
"""
Created on Mon Jul 17 20:58:55 2017

@author: mrinmoy sarkar
"""

import gzip
import numpy as np
import matplotlib.pyplot as canvas
import struct
import os
import sys


def loadData(src, noofsamples):
    try:
        with gzip.open(src) as gz:
            n = struct.unpack('I', gz.read(4))
            if n[0] != 0x3080000:
                raise Exception('Invalid file: unexpected magic number.')
                n = struct.unpack('>I', gz.read(4))[0]
                if n != noofsamples:
                    raise Exception('Invalid file: expected {0} entries.'.format(cimg))
                crow = struct.unpack('>I', gz.read(4))[0]
                ccol = struct.unpack('>I', gz.read(4))[0]
                if crow != 28 or ccol != 28:
                    raise Exception('Invalid file: expected 28 rows/cols per image.')
                # Read data.\n",
                res = np.fromstring(gz.read(noofsamples * crow * ccol), dtype = np.uint8)
    finally:
        print('data loaded successfully')
    return 0 #res.reshape((noofsamples, crow * ccol))






src = '../Dataset/train-images-idx3-ubyte.gz'
totaltrainingsample = 60000

trainingData = loadData(src, totaltrainingsample)
x = np.array([1, 2, 3])

canvas.plot(x)
