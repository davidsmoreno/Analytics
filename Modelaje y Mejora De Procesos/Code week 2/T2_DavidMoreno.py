import pulp as lp

# Conjuntos
I = ["Facebook", "Youtube", "Twitter", "TikTok", "LinkedIn"]

# Pámetros

a = {canal: val for canal, val in zip(I, (2, 5, 3, 4.5, 2.9))}
c = {canal: val for canal, val in zip(I, (3000, 4000, 2000, 2000, 3000))}
p = 10000
q = 0.3

print(a)
print(c)
print(p)
print(q)


# Pregunta 1

problema = lp.LpProblem("Maximizar ganancias", lp.LpMaximize)
print(problema)


# Pregunta 2
x = lp.LpVariable.dicts("Canales", I, lowBound=0, cat=lp.LpContinuous)

print(x)

# Pregunta 3
problema += lp.lpSum([a[i] * x[i] for i in I]), "Funcion Objetivo"

print(problema)

# Pregunta 4
for i in I:
    problema += x[i] <= c[i], "R1aa" + str(i)  ###Pregunta 4
    problema += lp.lpSum(x[i]) <= p, "R2aa"  ###Pregunta 5
    problema += lp.lpSum(x[i]) <= x["Facebook"], "R3aa"  ###Pregunta 6

solucion = problema.solve()
print(lp.LpStatus[solucion])
