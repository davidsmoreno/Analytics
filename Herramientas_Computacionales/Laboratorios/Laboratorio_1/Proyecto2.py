

directorio = './Archivos/'
Archivos=["edad.txt","escolaridad.txt","estado_civil.txt","estrato.txt","genero.txt","promedio.txt","region.txt"]


import math as math
import random as random


def read_txt(directorio):
    with open(directorio, "r") as f:
        lines = f.readlines()

    cleaned_lines = [line.strip() for line in lines]

    return cleaned_lines


matriz={}
for i in Archivos:
    file_path=directorio+str(i)
    content=read_txt(file_path)
    matriz[i]=content



#Media

def media(lista):
    return sum(lista)/len(lista)


edad=matriz["edad.txt"]


int_values_edad=[int(i) for i in edad] #Convert list string or object to int

print(media(int_values_edad))


import math as math

def mediana(lista):
    lista.sort()
    mediana=[]
    n=len(lista)
    if n%2==0:
        mediana=lista[math.trunc(n/2)]
    else:
        mediana=(lista[math.trunc(n/2)]+list[math.trunc(n/2-1)])/2
    return mediana


print(mediana(int_values_edad))




def varianza(data):
    n=len(data)
    mean=sum(data)/n
    square_diference=[(x-mean)**2 for x in data]
    variance=sum(square_diference)/n
    return variance


def desviacion(data):
    return (varianza(data)**0.5)

print(varianza(int_values_edad))
print(desviacion(int_values_edad))





#Para cada variable relevante en el problema.





##Varianza-Desviacion

