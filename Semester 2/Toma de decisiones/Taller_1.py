# Definición de parámetros
rf = 0.0409  # Tasa libre de riesgo
rm = 0.0680  # Retorno esperado del mercado
E = 387  # Valor del Equity en millones de USD
D = 115  # Valor de la Deuda en millones de USD
V = E + D  # Valor total de financiamiento

# Beta de las acciones (Equity (Levered) Beta) para la industria de transporte aéreo
# Este valor se obtiene de la hoja "Industry Average Beta (Global)" del archivo Excel
beta_industria_aereo = 0.81 # Beta desapalancado
beta_metales = 0.988828382860035

# Calculando el costo de capital propio (re) usando el modelo CAPM
def calcular_re(rf, beta, rm):
    return rf + beta * (rm - rf)

re_aereo = calcular_re(rf, beta_industria_aereo, rm)
re_metales = calcular_re(rf, beta_metales, rm)

# Suponiendo el costo de la deuda (rd) cercano a la tasa libre de riesgo
rd = rf 

# Calculando el WACC (Costo de Capital Promedio Ponderado)
def calcular_wacc(E, D, V, re, rd):
    return (E/V) * re + (D/V) * rd

WACC = calcular_wacc(E, D, V, re_aereo, rd)


print("Empresa de Transporte Aéreo")
print(f"Costo de capital propio (re): {re_aereo:.2%}")

WACC = calcular_wacc(E, D, V, re_metales, rd)


print("Empresa de Metales")
print(f"Costo de capital propio (re): {re_metales:.2%}")



