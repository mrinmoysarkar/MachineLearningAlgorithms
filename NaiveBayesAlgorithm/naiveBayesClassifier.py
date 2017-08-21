# -*- coding: utf-8 -*-
"""
Created on Sun Aug 13 21:35:47 2017

@author: mrinmoy sarkar
"""

import numpy as np
import math
import os
from os import listdir
from os.path import isfile, join
import matplotlib.pyplot as plt
import string





#load data
rootDirofDataSet = './20_newsgroups/'

allSubDirName = [x[0] for x in os.walk(rootDirofDataSet)]

allSubDirName.remove(rootDirofDataSet)

targetOutput = []
allInputs = []
noOfSample=0
for path in allSubDirName:
    path +="/"
    nameOfFile = [f for f in listdir(path) if isfile(join(path,f))]
    inputInstance = []
    for i in nameOfFile:
        file = path + i
        with open(file) as f:
            content = f.readlines()
            content = [x.strip() for x in content] 
            inputInstance.append(content)


















