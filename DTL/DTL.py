# -*- coding: utf-8 -*-
"""
Created on Thu Jul 20 13:17:54 2017

@author: mrinmoy sarkar
"""

import math

class feature():
    def __init__(self, name):
        self.name = name
        self.attributeNames = []
        self.positiveExample = {}
        self.negativeExample = {}
        self.positiveExampleOfFeature = []
        self.negativeExampleOfFeature = []
        
    def insertAttribute(self, attrName):
        if not self.attributeNames.__contains__(attrName):
            self.attributeNames.append(attrName)

    def insertPositiveExample(self, attrName, exampleInstance):
        self.positiveExampleOfFeature.append(exampleInstance)
        if not bool(self.positiveExample):
            self.positiveExample[attrName] = [exampleInstance]
        elif not (self.positiveExample.keys()).__contains__(attrName):
            self.positiveExample[attrName] = [exampleInstance]
        else:
              self.positiveExample[attrName].append(exampleInstance)  
              
    def insertNegativeExample(self, attrName, exampleInstance):
        self.negativeExampleOfFeature.append(exampleInstance)
        if not bool(self.negativeExample):
            self.negativeExample[attrName] = [exampleInstance]
        elif not (self.negativeExample.keys()).__contains__(attrName):
            self.negativeExample[attrName] = [exampleInstance]
        else:
              self.negativeExample[attrName].append(exampleInstance) 
            
class node():
    def __init__(self, name, attributes):
        self.name = name
        self.attributes = {i:0 for i in attributes}
        
        
        
        
        
        
def entropy(p,n):
    if p == 0 or n == 0:
        return 0
    else:
        return -(p/(p+n))*math.log2(p/(p+n)) - (n/(p+n))*math.log2(n/(p+n))      
        
def gainForWholeSpace(p,n,feature):
    E = 0
    for i in feature.attributeNames:
        p1 = 0
        if (feature.positiveExample.keys()).__contains__(i):
            p1 = len(feature.positiveExample[i])
        n1 = 0
        if (feature.negativeExample.keys()).__contains__(i):
            n1 = len(feature.negativeExample[i])
        E +=  ((p1 + n1)/(p+n)) * entropy(p1,n1)
    return entropy(p,n) - E

def gainForSubSpace(rootFeature, rootAttribute, leafFeature):
    p = 0
    if (rootFeature.positiveExample.keys()).__contains__(rootAttribute):
        p = len(rootFeature.positiveExample[rootAttribute])
    n = 0
    if (rootFeature.negativeExample.keys()).__contains__(rootAttribute):
        n = len(rootFeature.negativeExample[rootAttribute])
    ES = entropy(p,n)
    space = set(rootFeature.positiveExample[rootAttribute] + rootFeature.negativeExample[rootAttribute])
    E = 0
    for i in leafFeature.attributeNames:
        p1 = 0
        if (leafFeature.positiveExample.keys()).__contains__(i):
            p1 = len(space & set(leafFeature.positiveExample[i]))
        n1 = 0
        if (leafFeature.negativeExample.keys()).__contains__(i):
            n1 = len(space & set(leafFeature.negativeExample[i]))
        E += ((p1+n1)/(p+n)) * entropy(p1,n1)
    return ES - E
         
def addNode(rootNode, rootFeature, featureVector, usedFeature):
    for i in rootFeature.attributeNames:
        p1 = 0
        if (rootFeature.positiveExample.keys()).__contains__(i):
            p1 = len(rootFeature.positiveExample[i])
        n1 = 0
        if (rootFeature.negativeExample.keys()).__contains__(i):
            n1 = len(rootFeature.negativeExample[i])
        if entropy(p1,n1) == 0 or len(usedFeature) == len(featureVector):
            if p1 > n1:
                rootNode.attributes[i] = 1
            continue
        
        gain = []
        for j in range(0,len(featureVector)):
            if usedFeature.__contains__(j):
                gain.append(-100)
            else:
                gain.append(gainForSubSpace(rootFeature, i, featureVector[j]))
        
        #print("max gain: ", max(gain))   
        if max(gain) < 0.5:
            if p1 > n1:
                rootNode.attributes[i] = 1
            continue
        newFeature = featureVector[gain.index(max(gain))]
        newNode = node(newFeature.name, newFeature.attributeNames)
        rootNode.attributes[i] = newNode
        usedFeature.append(gain.index(max(gain)))
        addNode(rootNode.attributes[i], newFeature, featureVector, usedFeature[:])
         
         
         
         
# main function starts from here     
i=0
positiveExample = 0
negativeExample = 0
with open("noisy10_train.ssv", "r") as trainData:
    for instanceX in trainData:
        if i==1:
            featureName = instanceX.split()
            featureVector = [feature(featureName[j+1]) for j in range(0,len(featureName)-1)]
        elif i > 2:
            attr = instanceX.split()
            if attr[0] == '1':
                positiveExample += 1
            elif attr[0] == '0':
                negativeExample += 1
            
            for j in range(0,len(attr)-1):
                featureVector[j].insertAttribute(attr[j+1])
                if attr[0] == '1':
                    featureVector[j].insertPositiveExample(attr[j+1], i)
                elif attr[0] == '0':
                    featureVector[j].insertNegativeExample(attr[j+1],i)
        i+=1
        #if i == 200:
        #    break
        
usedFeature = [] 
gain = []

for i in range(0,len(featureVector)):
    gain.append(gainForWholeSpace(positiveExample, negativeExample, featureVector[i]))

rootFeature = featureVector[gain.index(max(gain))] 

rootNode = node(rootFeature.name, rootFeature.attributeNames)

usedFeature.append(gain.index(max(gain)))

addNode(rootNode, rootFeature, featureVector, usedFeature[:])

print('training Done')


#testing starts here
i=0
correct = 0
incorrect = 0
with open("noisy10_test.ssv", "r") as trainData:
    for instanceX in trainData:
        if i==1:
            featureName = instanceX.split()
        elif i > 2:
            attr = instanceX.split()
            traverseNode = rootNode
            while True:
                #print(traverseNode.name)
                nextNode = traverseNode.attributes[attr[featureName.index(traverseNode.name)]]
                if nextNode == 0 or nextNode == 1 :
                    if (nextNode == 0 and attr[0] == '0') or (nextNode == 1 and attr[0] == '1'):
                        correct += 1
                    else:
                        incorrect += 1
                    break
                traverseNode = nextNode
        i+=1
        #if i == 10:
        #    break

print('correct: ', correct,' incorrect: ', incorrect)
print('success rate in %: ', math.ceil((correct * 100)/(correct+incorrect)))
print('test done')




