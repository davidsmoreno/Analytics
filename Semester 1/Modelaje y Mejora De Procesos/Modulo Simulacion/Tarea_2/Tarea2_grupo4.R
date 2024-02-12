# Simulaci???n de Eventos Discretos
#################################################

##Instalaci???n de los paquetes utilizados
install.packages("MASS")
install.packages("survival")
install.packages("fitdistrplus")

##Cargar los paquetes
library(MASS)
library(survival)
library(fitdistrplus)

############################################################################################
## Cargar serie de datos:
#datos <- read.csv("mmps_clase2_datos.csv", header=TRUE, sep=",")
datos <-
  read.csv(
    "C:\\Users\\David\\Documents\\Analytics\\Modelaje y Mejora De Procesos\\Modulo Simulacion\\Tarea_2\\mmps_clase2_datos.csv"
  )
table(datos['FranjaHoraria'])

############################################################################################
## Histograma de la serie de datos.
hist(
  datos$TiempoEntreArribos,
  main = "Histograma de la serie de datos",
  xlab = "Hora entre Arribos",
  las = 1,
  pro = FALSE
)

############################################################################################
## Pruebas de bondad y ajuste

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(datos$TiempoEntreArribos, "lnorm")

# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"

## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)


fendo.ln <- fitdist(datos$TiempoEntreArribos, "exp")
fendo.ll <- fitdist(datos$TiempoEntreArribos, "cauchy")
fendo.P <- fitdist(datos$TiempoEntreArribos, "gamma")
fendo.B <- fitdist(datos$TiempoEntreArribos, "lnorm")
fendo.C <- fitdist(datos$TiempoEntreArribos, "logis")
fendo.C <- fitdist(datos$TiempoEntreArribos, "norm")
cdfcomp(
  list(fendo.ln, fendo.ll, fendo.P, fendo.B, fendo.C),
  xlogscale = TRUE,
  ylogscale = TRUE,
  legendtext = c(
    "Exponencial",
    "Cauchy",
    "Gamma",
    "Lognormal",
    'Log�stica',
    'Normal'
  )
)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


##############################*##############################################################
### Prueba de homogeneidad de varianzas

#Filtrar la tabla por las 2 franjas horarias que voy a comparar
dosniveles <- datos[datos$FranjaHoraria %in% c("1", "2"),]

#Prueba de varianzas iguales
res.ftest <-
  var.test(dosniveles$TiempoEntreArribo ~ dosniveles$FranjaHoraria,
           data = dosniveles)

#Resultados test F
res.ftest

############################################################################################
### Prueba de diferencia de medias

#Filtrar la tabla por las 2 franjas horarias que voy a comparar
dosniveles <- datos[datos$FranjaHoraria %in% c("1", "2"),]

# Prueba de diferencia de medias
res.ttest <-
  t.test(dosniveles$TiempoEntreArribo ~ dosniveles$FranjaHoraria,
         data = dosniveles)

# Resultados prueba diferencia de medias
res.ttest

##############################*##############################################################
### Prueba de homogeneidad de varianzas

#Filtrar la tabla por las 2 franjas horarias que voy a comparar
dosniveles <- datos[datos$FranjaHoraria %in% c("1", "3"),]

#Prueba de varianzas iguales
res.ftest <-
  var.test(dosniveles$TiempoEntreArribo ~ dosniveles$FranjaHoraria,
           data = dosniveles)

#Resultados test F
res.ftest

############################################################################################
### Prueba de diferencia de medias

#Filtrar la tabla por las 2 franjas horarias que voy a comparar
dosniveles <- datos[datos$FranjaHoraria %in% c("1", "3"),]

# Prueba de diferencia de medias
res.ttest <-
  t.test(dosniveles$TiempoEntreArribo ~ dosniveles$FranjaHoraria,
         data = dosniveles)

# Resultados prueba diferencia de medias
res.ttest

##############################*##############################################################
### Prueba de homogeneidad de varianzas

#Filtrar la tabla por las 2 franjas horarias que voy a comparar
dosniveles <- datos[datos$FranjaHoraria %in% c("2", "3"),]

#Prueba de varianzas iguales
res.ftest <-
  var.test(dosniveles$TiempoEntreArribo ~ dosniveles$FranjaHoraria,
           data = dosniveles)

#Resultados test F
res.ftest

############################################################################################
### Prueba de diferencia de medias

#Filtrar la tabla por las 2 franjas horarias que voy a comparar
dosniveles <- datos[datos$FranjaHoraria %in% c("2", "3"),]

# Prueba de diferencia de medias
res.ttest <-
  t.test(dosniveles$TiempoEntreArribo ~ dosniveles$FranjaHoraria,
         data = dosniveles)

# Resultados prueba diferencia de medias
res.ttest


############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("1"),]

## Histograma de la serie de datos.
hist(
  franjahoraria$TiempoEntreArribo,
  main = "Histograma de la serie de datos",
  las = 1,
  prob = FALSE
)

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "exp")

## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


## Franja 1
### Exponencial

############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("1"),]

## Histograma de la serie de datos.
hist(
  franjahoraria$TiempoEntreArribo,
  main = "Histograma de la serie de datos Franja 1",
  las = 1,
  prob = FALSE
)

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "exp")

## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Gamma
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("1"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "gamma")

## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Normal
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("1"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "norm")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Log normal
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("1"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "lnorm")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Weibull
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("1"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "weibull")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)

### Cauchy
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("1"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "cauchy")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)

## Franja 2


### Exponencial
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("2"),]

## Histograma de la serie de datos.
hist(
  franjahoraria$TiempoEntreArribo,
  main = "Histograma de la serie de datos Franja 2",
  las = 1,
  prob = FALSE
)

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "exp")

## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Gamma
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("2"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "gamma")

## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Normal
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("2"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "norm")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Log normal
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("2"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "lnorm")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Weibull
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("2"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "weibull")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)

### Cauchy
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("2"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "cauchy")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)

### Log normal
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("2"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "lnorm")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)

### Uniforme
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("2"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "unif")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)

## Franja 3

### Exponencial
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("3"),]

## Histograma de la serie de datos.
hist(
  franjahoraria$TiempoEntreArribo,
  main = "Histograma de la serie de datos Franja 3",
  las = 1,
  prob = FALSE
)

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "exp")

## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Gamma
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("3"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "gamma")

## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Normal
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("3"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "norm")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Log normal
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("3"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "lnorm")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)


### Weibull
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("3"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "weibull")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)

### Cauchy
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("3"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "cauchy")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)

### Beta
############################################################################################
##  Bondad de ajuste para la franja horaria 1
franjahoraria <- datos[datos$FranjaHoraria %in% c("3"),]

## Almacenar la estimaci???n por m???xima verosimilitud de la serie de datos
## a una distribuci???n de probabilidad ingresada por par???metro.
ajuste <- fitdist(franjahoraria$TiempoEntreArribo, "logis")
# "beta", "cauchy", "chi-squared", "exponential", "f", "gamma", "geometric", "log-normal",
# "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull"
## Mostrar los par???metros del ajuste a la distribuci???n dada.
print(ajuste$estimate)

## Mostrar las gr???ficas de inter???s de las distribuciones emp???rica y te???rica.
plot(ajuste)

## Realizar y guardar prueba de bondad de ajuste a la serie de datos con respecto a
## la distribuci???n te???rica escogida.
resultados <- gofstat(ajuste)

## Rechazo de la prueba de Kolmogorov-Smirnov
print(resultados$kstest)

## P-Value de la prueba de Chi-Cuadrado
print(resultados$chisqpvalue)