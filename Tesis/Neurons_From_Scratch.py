# Que vamos a necesitar para la creacion de las redes

import numpy as np
import matplotlib.pyplot as plt


### Cuales son los parametros que tienen las redes neuronales
## Tienen unos pesos (Weights) y un bias 


class Network(object):
    def __init__(self,sizes):
        self.num_layers=len(sizes)
        self.sizes=sizes
        self.biases=[np.random.randn(y,1) for y in sizes[1:]] ##Shape y rows and 1 column
        self.weigths=[np.random(y,x) for x,y in zip(sizes[:-1],sizes[1:])]

    def feedforward(self,a):
        for b,w in zip(self.biases,self.weights):
            a=sigmoid(np.dot(w,a)+b)

    def update_mini_batch(self,mini_batch,eta):
        nabla_b=[np.zeros(b.shape) for b in self.biases]
        nabla_w=[np.zeros(w.shape) for w in self.weights]
        for x,y in mini_batch:
            delta_nabla_b=delta_nabla_w=self.backprop(x,y)
            nabla_b=[nb+dnb for nb,dnb in zip(nabla_b,delta_nabla_b)]
            nabla_w=[nw+dnw for nw,dnw in zip(nabla_w,delta_nabla_w)]
        self.weigths=[w-(eta/len(mini_batch))*nw for w,nw in zip(self.weights,nabla_w)]
        self.biases=[b-(eta/len(mini_batch))*nb for b,nb in zip(self.biases,nabla_b)]

        