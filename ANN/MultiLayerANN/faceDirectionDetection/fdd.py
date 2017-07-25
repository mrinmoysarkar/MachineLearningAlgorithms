# -*- coding: utf-8 -*-
"""
Created on Fri Jul 21 21:37:20 2017

@author: mrinmoy sarkar
"""
import cv2 as cv
import numpy as np
import sys
import math
import os
from os import listdir
from os.path import isfile, join
import matplotlib.pyplot as plt


def sigmoid(x):
    return 1.0/(1.0 + np.exp(-x))

def calcOutput(x,w1,w2):
    productSum = np.matmul(np.transpose(w1), x)
    oh = sigmoid(productSum)
    productSum = np.matmul(np.transpose(w2), oh)
    oo = sigmoid(productSum)
    return oo

def mapToRange(x,p1,p2,n1,n2):
    return ((n1-n2)/(p1-p2))*(x-p1) + n1

def encodeOutput(x):
    if x.__contains__("left"):
        return [0.9,0.1,0.1,0.1]
    elif x.__contains__("right"):
        return [0.1,0.9,0.1,0.1]
    elif x.__contains__("straight"):
        return [0.1,0.1,0.9,0.1]
    elif x.__contains__("up"):
        return [0.1,0.1,0.1,0.9]

rootDirofDataSet = '../faces_4/'

allSubDirName = [x[0] for x in os.walk(rootDirofDataSet)]

allSubDirName.remove(rootDirofDataSet)


targetOutput = []
allInputs = []
noOfSample=0
for path in allSubDirName:
    path +="/"
    nameOfFile = [f for f in listdir(path) if isfile(join(path,f))]
    for i in nameOfFile:
        targetOutput.append(encodeOutput(i))
        img = cv.imread(path+i, cv.IMREAD_GRAYSCALE)
        tempdata = np.array(img, np.float)
        tempdata = tempdata/256.0#mapToRange(tempdata,255,0,1,0)
        allInputs.append(tempdata.reshape(1,960))
    noOfSample+=len(nameOfFile)

targetOutput = np.array(targetOutput,np.float)
allInputs = np.array(allInputs,np.float)
print("No Of file: ", noOfSample)
#img = cv.imread(path+nameOfFile[0], cv.IMREAD_GRAYSCALE)

#data = np.array(img, np.float)
#data1 = mapToRange(data,255,0,0,1)
#cv.namedWindow("window1")
#cv.imshow("window1",img)
#cv.waitKey(0)
#b,g,r = cv.split(img)
#frame_rgb = cv.merge((r,g,b))
#plt.imshow(frame_rgb)
#plt.imshow(img)



#T=[0.1,0.05,0.3]    
#X=[[0.4,-0.7],[0.3,-0.5],[0.6,0.1]]



eta = 0.3
alph = 0.3

hiddenunit = 60
inputunit = 960
outputunit = 4

noOfIteration = 10000
noOfTestSample = 412

w1 = mapToRange(np.random.random([inputunit,hiddenunit]),1.0,0,0.05,-0.05) #np.transpose(np.ndarray(shape=(2,2), buffer=np.array([[0.1, 0.4],[-0.2, 0.2]]), dtype=np.float)) #/2.0
w2 = mapToRange(np.random.random([hiddenunit,outputunit]),1.0,0,0.05,-0.05) #np.transpose(np.ndarray(shape=(2,1), buffer=np.array([0.2, -0.5]), dtype=np.float))

E=[]

j=0
error = 100

cerror = 0

dw1 = np.zeros([inputunit,hiddenunit])
dw2 = np.zeros([hiddenunit,outputunit])

r1 = 0
while error>0.001 and j<noOfIteration:
    error = 0
    for i in range(0,noOfTestSample):             #len(T)):
        target = np.transpose(np.array([targetOutput[i]]))       #np.array([[T[i]]], dtype=np.float)
        x = np.transpose(allInputs[i])                           #np.transpose(np.ndarray(shape=(1,2), buffer=np.array(X[i]), dtype=np.float))
        
        productSum = np.matmul(np.transpose(w1), x)
        outputHL = sigmoid(productSum)
        productSum = np.matmul(np.transpose(w2), outputHL)
        outputOL = sigmoid(productSum)
        error += 0.5 * sum((target-outputOL)**2)
        k2 = (target - outputOL) * outputOL * (1 - outputOL)
        dw2 += np.matmul(outputHL, np.transpose(k2))
        
        k1 = outputHL * (1 - outputHL)
        p = np.matmul(w2,k2) * k1
        dw1 +=  np.matmul(x,np.transpose(p))
        
    w1 = alph*w1 + eta*(dw1/noOfTestSample)
    w2 = alph*w2 + eta*(dw2/noOfTestSample)
    E.append(error/noOfTestSample)
    #r1+=64
    #r1 %= 256
    j+=1    
plt.plot(E)

error = 0
n = 0
for i in range(noOfTestSample,noOfSample):
    x = np.transpose(allInputs[i]) 
    o = np.transpose(calcOutput(x,w1,w2))
    t = np.array([targetOutput[i]])
    indx = list(o[0]).index(max(o[0]))
    o = np.zeros([1,4])
    o[0][indx] = 1
    
    indx = list(t[0]).index(max(t[0]))
    t = np.zeros([1,4])
    t[0][indx] = 1
    print("target : ", t, " output : ", o)
    if list(t[0]) != list(o[0]):
        error += 1
    n += 1
    
er = math.floor((error/n)*100.0)
sr = 100 - er
print("ERROR RATE(%): ", er, " SUCCESS RATE(%): ", sr)
#X = [[0.4,-0.7],[0.3,-0.5],[0.6,0.1],[0.2,0.4],[0.1,-0.2]]

#for i in X:
#    x = np.transpose(np.ndarray(shape=(1,2), buffer=np.array(i), dtype=np.float))
#    print("Output : ",calcOutput(x,w1,w2))