# Que vamos a necesitar para la creacion de las redes

import numpy as np
import matplotlib.pyplot as plt


### Cuales son los parametros que tienen las redes neuronales
## Tienen unos pesos (Weights) y un bias 

def init_params(layers_dim):
    np.random.seed(3)
    params = {}
    L = len(layers_dim)

    for l in range(1,L):
        params['W'+str(l)]=np.random.randn(layers_dim[l],layers_dim[l-1])*0.01
        params['b'+str(l)]=np.zeros((layers_dim[l],1))
    return params



##Ejemplo
layes_dim = [5,4,3]

np.random.seed(3)
