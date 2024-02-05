import pandas as pd
import pulp as lp


archivo = "Soporte Caso 6.xlsx"
arcos=pd.read_excel(io=archivo,sheet_name="Arcos")
nodos=pd.read_excel(io=archivo,sheet_name="Nodos")


Nodos = list(nodos.i)

# Arcos del grafo
Arcos = [(str(row.i), row.j) for _, row in arcos.iterrows()]

# Demanda/oferta de cada nodo
b = {str(row.i): row.b for _, row in nodos.iterrows()}

# Costo de cada arco
c = {(str(row.i), row.j): round(row.c, 2) for _, row in arcos.iterrows()}

# Flujo máximo de cada arco
u = {(str(row.i), row.j): row.u for _, row in arcos.iterrows()}

