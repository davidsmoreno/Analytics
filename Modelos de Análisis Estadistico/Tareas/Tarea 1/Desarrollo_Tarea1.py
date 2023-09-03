
#- Identifique los departamentos donde los estudiantes obtuvieron un puntaje en matemáticas
#mayor a 55, un puntaje en lectura mayor a 60 y un puntaje en ingles mayor a 70 
#reemplace estos valores por valores perdidos. En lo que sigue trabaje con estas variables 
#corregidas.<br> 

#- Calcule nuevamente la media, desviación estándar, máximo, mínimo. Compare los resultados con los hallados los 2 literales anteriores y comente. 
### Ejercicio 1
#(40%) La base de datos contenida en resultadosicfes.csv tiene información de los 
#resultados obtenidos en 2019, estos resultados muestran todos los departamentos de 
#Colombia, por favor tomar como muestra los resultados de los siguientes 5 departamentos; La 
#Guajira, Valle, Atlántico, Bogotá (la cual en las estadísticas se tiene como departamento) y 
#Huila. El objetivo es realizar un análisis exploratorio de los datos.

import pandas as pd
import numpy as np

resultados_icfes = pd.read_csv('Archivos/resultadosicfes.csv', sep = ';',encoding='utf-8')

unique_departamentos = resultados_icfes['ESTU_DEPTO_RESIDE'].unique()

resultados_icfes_5= resultados_icfes.loc[resultados_icfes['ESTU_DEPTO_RESIDE'].isin(['LA GUAJIRA','VALLE','ATLANTICO','BOGOTÃ\x81','HUILA'])]

summary=resultados_icfes_5.describe()
data_type=resultados_icfes_5.dtypes

variables_continuas = ['PUNT_MATEMATICAS','PUNT_LECTURA_CRITICA','PUNT_C_NATURALES','PUNT_SOCIALES_CIUDADANAS','PUNT_INGLES','PUNT_GLOBAL','PERCENTIL_GLOBAL']

##Valores perdidos para cada variable Punto a_1
resultados_icfes_5[variables_continuas].isnull().sum()

#Calculate the mean, std, max and min

#calculate describe group by ESTU_DEPTO_RESIDE
summary_group=resultados_icfes_5.groupby('ESTU_DEPTO_RESIDE')[variables_continuas].describe()


#######

##Identifique los departamentos donde los estudiantes obtuvieron un puntaje  ....

condiciones= (resultados_icfes_5['PUNT_MATEMATICAS']>55) & (resultados_icfes_5['PUNT_LECTURA_CRITICA']>60) & (resultados_icfes_5['PUNT_INGLES']>70)

l1=resultados_icfes_5.loc[condiciones,['PUNT_MATEMATICAS','PUNT_LECTURA_CRITICA','PUNT_INGLES']]=np.nan

#calculate again the mean, std, max and min

