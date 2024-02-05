import matplotlib.pyplot as plt
import pandas as pd
import pulp as lp

plt.style.use('seaborn')


Pozos = [
    "DELE B-1",
    "EL MORRO-1",
    "FLORENA A-5",
    "FLORENA C-6",
    "FLORENA N-2",
    "FLORENA N-4 ST",
    "FLORENA-T8",
    "PAUTO J-6",
    "PAUTO M4",
    "PAUTO M-5",
    "PAUTO SUR B-1",
    "PAUTO SUR C-2",
    "PAUTO-1",
    "VOLCANERA A-1",
    "VOLCANERA C-2",
]

# Conjunto de años
Tiempos = range(1, 11)  # No incluye 11

# Conjunto de tuplas (pozo, año)
Pozo_x_Tiempo = [(i, t) for i in Pozos for t in Tiempos]
# Parámetros no indexados
presupuesto = 120  # Presupuesto máximo
maxProyectos = 12  # Máximo número de proyectos a realizar - restricción ambiental
maxOperarios = 6  # Máximo número de operarios por año
maxGeneradores = 6  # Máximo número de generadores por año

# Parámetros indexados en años
metas = {  # tiempo: meta (miles de barriles por día)
    1: 3,
    2: 4,
    3: 5,
    4: 4,
    5: 5,
    6: 3,
    7: 5,
    8: 4,
    9: 4,
    10: 6,
}

# Parámetros indexados en los pozos (abajo se separan en diccionarios diferentes)
dataPozos = {  # pozo: prod.minima, prod.moda, prod.máxima, operarios, generadores
    "DELE B-1": [1, 3, 4, 3, 3],
    "EL MORRO-1": [3, 4, 6, 2, 3],
    "FLORENA A-5": [3, 6, 7, 4, 2],
    "FLORENA C-6": [1, 3, 6, 4, 3],
    "FLORENA N-2": [4, 6, 10, 3, 2],
    "FLORENA N-4 ST": [1, 4, 6, 4, 3],
    "FLORENA-T8": [2, 4, 8, 2, 2],
    "PAUTO J-6": [2, 3, 5, 3, 2],
    "PAUTO M4": [3, 5, 7, 3, 3],
    "PAUTO M-5": [1, 4, 8, 4, 2],
    "PAUTO SUR B-1": [4, 5, 7, 2, 4],
    "PAUTO SUR C-2": [4, 6, 8, 3, 3],
    "PAUTO-1": [3, 5, 8, 3, 2],
    "VOLCANERA A-1": [4, 5, 9, 2, 3],
    "VOLCANERA C-2": [2, 5, 7, 2, 2],
}

# Parámetros indexados en los pozos y los años (abajo se separan en diccionarios diferentes)
dataPozoAño = {  # (pozo, año):   costo utilidad
    ("DELE B-1", 1): [13, 14],
    ("EL MORRO-1", 1): [21, 81],
    ("FLORENA A-5", 1): [8, 81],
    ("FLORENA C-6", 1): [7, 93],
    ("FLORENA N-2", 1): [3, 26],
    ("FLORENA N-4 ST", 1): [23, 77],
    ("FLORENA-T8", 1): [6, 88],
    ("PAUTO J-6", 1): [2, 13],
    ("PAUTO M4", 1): [9, 57],
    ("PAUTO M-5", 1): [12, 34],
    ("PAUTO SUR B-1", 1): [2, 10],
    ("PAUTO SUR C-2", 1): [21, 20],
    ("PAUTO-1", 1): [12, 43],
    ("VOLCANERA A-1", 1): [16, 51],
    ("VOLCANERA C-2", 1): [22, 44],
    ("DELE B-1", 2): [25, 55],
    ("EL MORRO-1", 2): [9, 54],
    ("FLORENA A-5", 2): [15, 70],
    ("FLORENA C-6", 2): [14, 40],
    ("FLORENA N-2", 2): [23, 65],
    ("FLORENA N-4 ST", 2): [5, 55],
    ("FLORENA-T8", 2): [10, 24],
    ("PAUTO J-6", 2): [23, 92],
    ("PAUTO M4", 2): [10, 58],
    ("PAUTO M-5", 2): [3, 26],
    ("PAUTO SUR B-1", 2): [16, 72],
    ("PAUTO SUR C-2", 2): [11, 39],
    ("PAUTO-1", 2): [2, 57],
    ("VOLCANERA A-1", 2): [15, 51],
    ("VOLCANERA C-2", 2): [8, 45],
    ("DELE B-1", 3): [17, 74],
    ("EL MORRO-1", 3): [22, 23],
    ("FLORENA A-5", 3): [12, 44],
    ("FLORENA C-6", 3): [11, 31],
    ("FLORENA N-2", 3): [7, 53],
    ("FLORENA N-4 ST", 3): [12, 71],
    ("FLORENA-T8", 3): [12, 80],
    ("PAUTO J-6", 3): [17, 22],
    ("PAUTO M4", 3): [14, 59],
    ("PAUTO M-5", 3): [15, 34],
    ("PAUTO SUR B-1", 3): [24, 88],
    ("PAUTO SUR C-2", 3): [25, 61],
    ("PAUTO-1", 3): [8, 46],
    ("VOLCANERA A-1", 3): [14, 33],
    ("VOLCANERA C-2", 3): [17, 15],
    ("DELE B-1", 4): [19, 75],
    ("EL MORRO-1", 4): [6, 70],
    ("FLORENA A-5", 4): [23, 18],
    ("FLORENA C-6", 4): [16, 36],
    ("FLORENA N-2", 4): [14, 44],
    ("FLORENA N-4 ST", 4): [18, 34],
    ("FLORENA-T8", 4): [6, 22],
    ("PAUTO J-6", 4): [20, 30],
    ("PAUTO M4", 4): [5, 93],
    ("PAUTO M-5", 4): [7, 68],
    ("PAUTO SUR B-1", 4): [25, 12],
    ("PAUTO SUR C-2", 4): [13, 75],
    ("PAUTO-1", 4): [12, 56],
    ("VOLCANERA A-1", 4): [10, 16],
    ("VOLCANERA C-2", 4): [6, 11],
    ("DELE B-1", 5): [7, 54],
    ("EL MORRO-1", 5): [8, 58],
    ("FLORENA A-5", 5): [22, 15],
    ("FLORENA C-6", 5): [17, 29],
    ("FLORENA N-2", 5): [20, 95],
    ("FLORENA N-4 ST", 5): [17, 32],
    ("FLORENA-T8", 5): [10, 91],
    ("PAUTO J-6", 5): [6, 29],
    ("PAUTO M4", 5): [6, 72],
    ("PAUTO M-5", 5): [25, 91],
    ("PAUTO SUR B-1", 5): [21, 95],
    ("PAUTO SUR C-2", 5): [15, 63],
    ("PAUTO-1", 5): [17, 64],
    ("VOLCANERA A-1", 5): [12, 54],
    ("VOLCANERA C-2", 5): [17, 19],
    ("DELE B-1", 6): [10, 84],
    ("EL MORRO-1", 6): [13, 48],
    ("FLORENA A-5", 6): [9, 10],
    ("FLORENA C-6", 6): [25, 32],
    ("FLORENA N-2", 6): [17, 92],
    ("FLORENA N-4 ST", 6): [25, 21],
    ("FLORENA-T8", 6): [5, 62],
    ("PAUTO J-6", 6): [23, 28],
    ("PAUTO M4", 6): [22, 87],
    ("PAUTO M-5", 6): [7, 97],
    ("PAUTO SUR B-1", 6): [25, 88],
    ("PAUTO SUR C-2", 6): [19, 88],
    ("PAUTO-1", 6): [4, 66],
    ("VOLCANERA A-1", 6): [6, 32],
    ("VOLCANERA C-2", 6): [5, 2],
    ("DELE B-1", 7): [12, 94],
    ("EL MORRO-1", 7): [3, 45],
    ("FLORENA A-5", 7): [19, 15],
    ("FLORENA C-6", 7): [4, 40],
    ("FLORENA N-2", 7): [6, 103],
    ("FLORENA N-4 ST", 7): [21, 9],
    ("FLORENA-T8", 7): [13, 63],
    ("PAUTO J-6", 7): [8, 25],
    ("PAUTO M4", 7): [15, 94],
    ("PAUTO M-5", 7): [8, 113],
    ("PAUTO SUR B-1", 7): [10, 99],
    ("PAUTO SUR C-2", 7): [12, 100],
    ("PAUTO-1", 7): [3, 70],
    ("VOLCANERA A-1", 7): [12, 29],
    ("VOLCANERA C-2", 7): [7, 13],
    ("DELE B-1", 8): [23, 104],
    ("EL MORRO-1", 8): [13, 42],
    ("FLORENA A-5", 8): [16, 21],
    ("FLORENA C-6", 8): [7, 48],
    ("FLORENA N-2", 8): [4, 94],
    ("FLORENA N-4 ST", 8): [11, 5],
    ("FLORENA-T8", 8): [20, 63],
    ("PAUTO J-6", 8): [15, 22],
    ("PAUTO M4", 8): [22, 100],
    ("PAUTO M-5", 8): [21, 129],
    ("PAUTO SUR B-1", 8): [19, 110],
    ("PAUTO SUR C-2", 8): [14, 113],
    ("PAUTO-1", 8): [15, 74],
    ("VOLCANERA A-1", 8): [8, 27],
    ("VOLCANERA C-2", 8): [19, 20],
    ("DELE B-1", 9): [8, 114],
    ("EL MORRO-1", 9): [23, 39],
    ("FLORENA A-5", 9): [2, 25],
    ("FLORENA C-6", 9): [23, 56],
    ("FLORENA N-2", 9): [23, 87],
    ("FLORENA N-4 ST", 9): [20, 10],
    ("FLORENA-T8", 9): [11, 63],
    ("PAUTO J-6", 9): [20, 19],
    ("PAUTO M4", 9): [8, 107],
    ("PAUTO M-5", 9): [15, 144],
    ("PAUTO SUR B-1", 9): [12, 121],
    ("PAUTO SUR C-2", 9): [6, 120],
    ("PAUTO-1", 9): [2, 78],
    ("VOLCANERA A-1", 9): [5, 33],
    ("VOLCANERA C-2", 9): [25, 24],
    ("DELE B-1", 10): [14, 124],
    ("EL MORRO-1", 10): [19, 36],
    ("FLORENA A-5", 10): [22, 32],
    ("FLORENA C-6", 10): [13, 50],
    ("FLORENA N-2", 10): [20, 80],
    ("FLORENA N-4 ST", 10): [16, 8],
    ("FLORENA-T8", 10): [9, 64],
    ("PAUTO J-6", 10): [7, 16],
    ("PAUTO M4", 10): [15, 113],
    ("PAUTO M-5", 10): [10, 160],
    ("PAUTO SUR B-1", 10): [5, 132],
    ("PAUTO SUR C-2", 10): [2, 115],
    ("PAUTO-1", 10): [16, 82],
    ("VOLCANERA A-1", 10): [25, 40],
    ("VOLCANERA C-2", 10): [18, 32],
}

# Separando datos en diccionarios independientes (comparten las misma llaves)
(prodMin, prodModa, prodMax, operarios, generadores) = lp.splitDict(dataPozos)
(costo, utilidad) = lp.splitDict(dataPozoAño)



def case1():
    problema=lp.LpProblem("Maximizar utilidad",lp.LpMaximize) #1
    x = lp.LpVariable.dicts("perforar", Pozo_x_Tiempo, lowBound=0, cat=lp.LpBinary) #2
    problema+=lp.lpSum(utilidad[(i,t)]*x[(i,t)] for i in Pozos for t in Tiempos),"Funcion objetivo" #3
    for i in Pozos:
        problema += lp.lpSum(x[(i, t)] for t in Tiempos) <= 1, f"Restriccion de un Pozo se explota máximo una vez {i}" #4
    problema+=lp.lpSum(x[(i,t)]*costo[(i,t)] for i in Pozos for t in Tiempos) <= presupuesto, "R2" #5

    dataPozoPronedio = {i: (prodMin[i] + prodMax[i]+prodModa[i]) / 3 for i in Pozos} #6
    for t in Tiempos: #6
        problema+=lp.lpSum(x[(i,t)]*dataPozoPronedio[i] for i in Pozos) >= metas[t], f"R_3{t}" #6
    for i in Tiempos: #7
        problema+=lp.lpSum(x[(i,t)]*operarios[i] for i in Pozos) <= maxOperarios, "R4_"+str(i) #7

    for t in Tiempos: #8
        problema+=lp.lpSum(x[(i,t)]*generadores[i] for i in Pozos) <= maxGeneradores, f"R_5"+str(t)#8

    problema+=lp.lpSum(x[(i,t)] for t in Tiempos for i in Pozos) <= maxProyectos, f"R_6"+str(t) #9
    return problema.solve(),x

problema,x=case1()


print("\nUtilidad total = $", lp.value(problema.objective))

# Inversión
print(
    "\nInversión total = $",
    sum(costo[i, t] * lp.value(x[i, t]) for i, t in Pozo_x_Tiempo),
    end="\n\n",
)

    





