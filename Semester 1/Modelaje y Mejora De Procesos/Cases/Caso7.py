import pulp as lp
import pandas as pd
from datetime import datetime

archivo = "Soporte Caso 7.xlsx"
turnos_esc_1 = pd.read_excel(archivo, sheet_name="Turnos Escenario 1")
turnos_esc_2 = pd.read_excel(archivo, sheet_name="Turnos Escenario 2")
costos_esc_1 = pd.read_excel(archivo, sheet_name="Costos Escenario 1")
costos_esc_2 = pd.read_excel(archivo, sheet_name="Costos Escenario 2")


# Conjunto turnos en el escenario 1
Turnos_1 = list(turnos_esc_1.columns[2:])

# Conjunto turnos en el escenario 2
Turnos_2 = list(turnos_esc_2.columns[2:])

# Conjunto de franjas horarias
Franjas = list(turnos_esc_1.Franjas)