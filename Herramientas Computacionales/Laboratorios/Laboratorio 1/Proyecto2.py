directorio = "./Archivos/"
Archivos=["edad.txt","escolaridad.txt","estado_civil.txt","estrato.txt","genero.txt","promedio.txt","region.txt"]


import math as math
import random as random


def read_txt(directorio):
    with open(directorio, "r") as f:
        lines = f.readlines()

    cleaned_lines = [line.strip() for line in lines]

    return cleaned_lines



Archivos=["edad.txt","escolaridad.txt","estado_civil.txt","estrato.txt","genero.txt","promedio.txt","region.txt"]


matriz={}
for i in Archivos:
    file_path=directorio+str(i)
    content=read_txt(file_path)
    matriz[i]=content
    
#Mision 1 Super


##Mision 2


#Calcula estadisticas decriptivas basicas media/mediana/varianza/desviacion


