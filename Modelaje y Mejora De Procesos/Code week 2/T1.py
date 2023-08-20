import pulp as lp

model = LpProblem("FurnitureProblem", LpMaximize)

x1 = LpVariable("tables", 0, None, LpInteger)
x2 = LpVariable("chairs", 0, None, LpInteger)
x3 = LpVariable("bookcases", 0, None, LpInteger)

model += 40 * x1 + 30 * x2 + 45 * x3

# Create three constraints
model += 2 * x1 + 1 * x2 + 2.5 * x3 <= 60, "Labour"
model += 0.8 * x1 + 0.6 * x2 + 1.0 * x3 <= 16, "Machine"
model += 30 * x1 + 20 * x2 + 30 * x3 <= 400, "wood"
model += x1 >= 10, "tables"

# The problem is solved using PuLP's choice of Solver
model.solve()

# Each of the variables is printed with it's resolved optimum value
for v in model.variables():
    print(v.name, "=", v.varValue)


##Tarea 2

# Conjuntos
I = ["Facebook", "Youtube", "Twitter", "TikTok", "LinkedIn"]

a = {canal: val for canal, val in zip(I, (2, 5, 3, 4.5, 2.9))}

c = {canal: val for canal, val in zip(I, (3000, 4000, 2000, 2000, 3000))}
p = 10000
q = 0.3


problema = lp.LpProblem("Maximizar ganancias", lp.LpMaximize)

x = lp.LpVariable.dicts("Canales", I, lowBound=0, cat=lp.Continuous)
problema = lp.LpProblem("Maximizar ganancias", lp.LpMaximize)
problema += lp.lpSum([a[i] * x[i] for i in I]), "Funcion Objetivo"

for i in I:
    problema += x[i] <= c[i], "Restriccion de presupuesto"

for i in I:
    problema += lp.Sum(x[i]) <= p, "Punto 6"


for i in I:
    problema += x[i] <= x["Facebook"], "Punto 7"

problema.solve()
