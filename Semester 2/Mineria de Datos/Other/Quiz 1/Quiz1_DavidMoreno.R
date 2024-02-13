# Load necessary packages
library(nycflights13)
library(dplyr)
library(ggplot2)

# Load the dataset
data("flights", package = "nycflights13")

# Display the structure of the dataset
str(flights)

# Display the summary of the dataset
summary(flights)

# Number of variables and observations
cat("Número de variables:", ncol(flights), "\nNúmero de observaciones:", nrow(flights), "\n")

# Exploratory analysis with the first 100 observations and print the plot
flights_100 <- head(flights, 100)
print(ggplot(flights_100, aes(x = dep_delay, y = arr_delay)) + 
        geom_point() + 
        theme_minimal() + 
        labs(title = "Relación entre Retraso de Salida y Llegada",
             x = "Retraso de Salida (minutos)",
             y = "Retraso de Llegada (minutos)"))

# Pearson correlation
cor(flights_100$dep_delay, flights_100$arr_delay, use = "complete.obs")


#Punto 2

# Cargar el paquete necesario
library(nycflights13)

# Cargar el dataset
data("flights", package = "nycflights13")

# Histograma con 10 intervalos
hist(flights$dep_delay, breaks = 10, main = "Histograma de Retrasos en las Salidas (10 intervalos)",
     xlab = "Retraso en Salida (minutos)", col = "lightblue", border = "black")

# Histograma con 20 intervalos
hist(flights$dep_delay, breaks = 20, main = "Histograma de Retrasos en las Salidas (20 intervalos)",
     xlab = "Retraso en Salida (minutos)", col = "lightgreen", border = "black")

# Histograma con la regla de Freedman-Diaconis
IQR_value <- IQR(flights$dep_delay, na.rm = TRUE)
n <- length(na.omit(flights$dep_delay))
binwidth <- 2 * IQR_value / (n^(1/3))
bins_fd <- ceiling((max(flights$dep_delay, na.rm = TRUE) - min(flights$dep_delay, na.rm = TRUE)) / binwidth)

hist(flights$dep_delay, breaks = bins_fd, main = "Histograma de Retrasos en las Salidas (Freedman-Diaconis)",
     xlab = "Retraso en Salida (minutos)", col = "lightcoral", border = "black")
## Prueba de kosmovorov


# Load the necessary library
library(nycflights13)

# Load the data
data("flights", package = "nycflights13")

# Prepare the data: remove NA values and ensure the data is positive
dep_delay_positive <- na.omit(flights$dep_delay)
dep_delay_positive <- dep_delay_positive[dep_delay_positive > 0]

# Estimate the rate parameter for the exponential distribution
rate_estimate <- 1 / mean(dep_delay_positive)

# Perform the Kolmogorov-Smirnov test
ks.test(dep_delay_positive, "pexp", rate_estimate)

## Punto 3


# Cargar el paquete necesario
library(nycflights13)

# Crear la base de datos sfo_feb_flights
sfo_feb_flights <- filter(flights, dest == "SFO", month == 2)

# Realizar un histograma para arr_delay
hist(sfo_feb_flights$arr_delay, main = "Histograma de Retrasos de Llegada a SFO en Febrero",
     xlab = "Retraso en Llegada (minutos)", col = "lightblue", border = "black")

# Calcular estadísticas de resumen para arr_delay
summary_stats <- summary(sfo_feb_flights$arr_delay)
print(summary_stats)

# Verificar las afirmaciones
media <- mean(sfo_feb_flights$arr_delay, na.rm = TRUE)
mediana <- median(sfo_feb_flights$arr_delay, na.rm = TRUE)
maximo_retraso <- max(sfo_feb_flights$arr_delay, na.rm = TRUE)
porcentaje_a_tiempo <- mean(sfo_feb_flights$arr_delay <= 0, na.rm = TRUE) * 100

list(media = media, mediana = mediana, maximo_retraso = maximo_retraso, porcentaje_a_tiempo = porcentaje_a_tiempo)


#Punto 4

# Cargar las bibliotecas necesarias
library(nycflights13)
library(ggplot2)

# Utilizar el dataset flights
data("flights", package = "nycflights13")

# Crear un boxplot de retrasos de salida por mes
ggplot(data = flights, aes(x = factor(month), y = dep_delay)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 1) +
  labs(title = "Retrasos de Salida por Mes en los Aeropuertos de Nueva York",
       x = "Mes",
       y = "Retraso de Salida (minutos)") +
  theme_minimal()


# Calcular la media de retrasos de salida por mes
mean_delays_by_month <- flights %>%
  group_by(month) %>%
  summarise(mean_delay = mean(dep_delay, na.rm = TRUE))

# Mostrar los resultados
print(mean_delays_by_month)



