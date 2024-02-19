# Read Inflow Data

##Set Location on Mac
#setwd("/Users/davidmoreno/Documents/University and Codes/Analytics/Semester 2/Mineria de Datos/Tarea 1")
#Sys.setenv(PATH = paste("/opt/homebrew/bin", Sys.getenv("PATH"), sep=":"))


# Importing libraries
library(dplyr)      # For data manipulation
library(ggplot2)    # For data visualization
library(tidyr)      # For data tidying
library(readr)      # For reading data
library(readxl)     # For reading excel files
library(psych)      # For descriptive statistics
library(zoo)        # For handling missing values




weather <- read_excel("WeatherData_1.xlsx", skip = 1, col_names = c("Date", "Rainfall depth (mm)", "Air temperature (°C)", "Air humidity (%)", "Windspeed (km/h)"))

# Read inflow data
inflow <- read_excel("InflowData_1.xlsx", skip = 1, col_names = c("Date", "DMA A", "DMA B", "DMA C", "DMA D", "DMA E", "DMA F", "DMA G", "DMA H", "DMA I", "DMA J"))

# Convert Date column to POSIXct format
weather$Date <- as.POSIXct(weather$Date, format = "%d/%m/%Y %H:%M")
inflow$Date <- as.POSIXct(inflow$Date, format = "%d/%m/%Y %H:%M")

# Merge inflow and weather data frames by "Date" column, retaining all rows from inflow
df_data <- merge(inflow, weather, by = "Date", all.x = TRUE)

# Remove duplicate rows based on the Date column, keeping only the first occurrence
df_data <- df_data[!duplicated(df_data$Date, fromLast = TRUE), ]

str(df_data)

df_data <- df_data %>%
  mutate(
    # First operation: Handle character columns
    across(where(is.character), ~ {
      # Replace "#N/A" with NA, then extract numbers and convert to numeric
      as.numeric(gsub("[^0-9.]+", "", ifelse(. == "#N/A", NA, .)))
    }),
    # Second operation: Convert DMA columns to integer
    across(c(`DMA A`, `DMA B`, `DMA C`, `DMA D`, `DMA E`, `DMA F`, `DMA G`, `DMA H`, `DMA I`, `DMA J`), as.integer)
  )
str(df_data)



# Calculate NA proportions for each column
na_proportions <- colMeans(is.na(df_data))

# Create a data frame with column names and NA proportions
na_summary <- data.frame(
  Column = names(na_proportions),
  NA_Proportion = na_proportions
)

# Arrange the summary data frame by NA proportions in descending order
na_summary <- na_summary %>%
  arrange(desc(NA_Proportion))

# Print the summary
print(na_summary)




df_data_1<-na.omit(df_data)


# Load the corrplot library
library(corrplot)

# Assuming num_df_data_1 is your numeric dataframe
# Calculate the correlation matrix
correlation_matrix <- cor(df_data_1, use = "complete.obs")

# Visualize the correlation matrix using corrplot
corrplot(correlation_matrix, 
         method = "color", 
         type = "upper", 
         order = "hclust",
         tl.col = "black", 
         tl.srt = 45, 
         addCoef.col = "black", 
         col = colorRampPalette(c("#6D9EC1", "white", "#E46726"))(200), 
         diag = FALSE)





numeric_cols <- sapply(df_data_1, is.numeric)

# Set up the plotting window to display multiple plots based on the number of numeric columns
par(mfrow=c(ceiling(sqrt(sum(numeric_cols))), ceiling(sqrt(sum(numeric_cols)))))

# Loop through each numeric column to create a histogram
for(col in names(df_data_1)[numeric_cols]) {
  hist(df_data_1[[col]], main = paste("Histogram of", col),
       xlab = col, ylab = "Frequency")
}

# Reset plotting window to default
par(mfrow=c(1, 1))




numeric_df <- df_data %>%
  select(where(is.numeric))

# Calculate the correlation matrix for numeric columns
correlation_matrix <- cor(numeric_df, use = "complete.obs")

# Visualize the correlation matrix using corrplot
corrplot(correlation_matrix, 
         method = "color", 
         type = "upper", 
         order = "hclust",
         tl.col = "black", 
         tl.srt = 45, 
         addCoef.col = "black", 
         col = colorRampPalette(c("#6D9EC1", "white", "#E46726"))(200), 
         diag = FALSE)



# Suponiendo que df_data_1 ya está cargado y preparado con las columnas de tiempo correctas
# Asegúrate de que Date esté en el formato de fecha adecuado, si no, conviértelo
df_data_1$Date <- as.POSIXct(df_data_1$Date, format="%d/%m/%Y %H:%M")
df_data_1$Hour <- hour(df_data_1$Date)

hourly_averages <- df_data_1 %>%
  group_by(Hour) %>%
  summarise(Average_DMA_A = mean(`DMA A`, na.rm = TRUE))

# Creamos el gráfico con ggplot2
ggplot(hourly_averages, aes(x = Hour, y = Average_DMA_A)) +
  geom_line() +  # Línea que conecta los puntos medios
  geom_point() +  # Puntos que representan los promedios reales por hora
  labs(title = "Media Móvil por Hora para DMA A", x = "Hora del Día", y = "Media de DMA A") +
  scale_x_continuous(breaks = 0:23) +  # Aseguramos que el eje x tenga las 24 horas
  theme_minimal()  # Tema minimalista para el gráfico




# Calculamos las medias móviles para los intervalos especificados
df_data_1$MA_5 <- rollapply(df_data_1$`DMA A`, width = 5, FUN = mean, fill = NA, align = 'right', na.rm = TRUE)
df_data_1$MA_10 <- rollapply(df_data_1$`DMA A`, width = 10, FUN = mean, fill = NA, align = 'right', na.rm = TRUE)
df_data_1$MA_13 <- rollapply(df_data_1$`DMA A`, width = 13, FUN = mean, fill = NA, align = 'right', na.rm = TRUE)
df_data_1$MA_60 <- rollapply(df_data_1$`DMA A`, width = 60, FUN = mean, fill = NA, align = 'right', na.rm = TRUE)
df_data_1$MA_90 <- rollapply(df_data_1$`DMA A`, width = 180, FUN = mean, fill = NA, align = 'right', na.rm = TRUE)

# Creamos el gráfico con ggplot2
ggplot(df_data_1, aes(x = Date)) +
  geom_line(aes(y = MA_5, color = "5 Días")) +
  geom_line(aes(y = MA_10, color = "10 Días")) +
  geom_line(aes(y = MA_13, color = "15")) +
  geom_line(aes(y = MA_60, color = "60 Días")) +
  geom_line(aes(y = MA_90, color = "180 Días")) +
  labs(title = "Moving Averages for DMA A", x = "Date", y = "DMA A") +
  scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month") +  # Adjust scale to show month and year
  theme_minimal() +
  theme(legend.position = "top")


# Cargamos las librerías necesarias
library(ggplot2)
library(dplyr)
library(lubridate)

# Extraemos la hora del día de la columna 'Date'
df_data_1$Hour <- hour(df_data_1$Date)

# Agrupamos por hora y calculamos la media para 'DMA A'
hourly_averages <- df_data_1 %>%
  group_by(Hour) %>%
  summarise(Average_DMA_A = mean(`DMA A`, na.rm = TRUE))

# Creamos el gráfico con ggplot2
ggplot(hourly_averages, aes(x = Hour, y = Average_DMA_A)) +
  geom_line() +  # Línea que conecta los puntos medios
  geom_point() +  # Puntos que representan los promedios reales por hora
  labs(title = "Media Móvil por Hora para DMA A", x = "Hora del Día", y = "Media de DMA A") +
  scale_x_continuous(breaks = 0:23) +  # Aseguramos que el eje x tenga las 24 horas
  theme_minimal()  # Tema minimalista para el gráfico


#######Gráfico por 


# Convertimos la columna 'Date' a tipo fecha si aún no lo está
df_data_1$Date <- as.Date(df_data_1$Date)

# Assuming df_data_1 is your dataframe
# Assuming df_data_1 is your dataframe
df_data_2 <- df_data_1 %>%
  mutate(Year = year(Date),
         Month = month(Date),
         YearMonth = as.yearmon(Date))

# Group by year and month to calculate the monthly average of DMA A
monthly_avg <- df_data_2 %>%
  group_by(YearMonth) %>%
  summarise(MonthlyAvg_DMA_A = mean(`DMA A`, na.rm = TRUE))

# Calculate the one-month moving average for the monthly averages of DMA A
monthly_avg$MovingAvg_1M <- rollapply(monthly_avg$MonthlyAvg_DMA_A, width = 1, FUN = mean, by.column = TRUE, fill = NA, align = 'right')

# Visualization with ggplot2
if (!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)

ggplot(monthly_avg, aes(x = YearMonth, y = MovingAvg_1M)) +
  geom_line() +
  geom_point() +
  labs(title = "1-Month Moving Average of Monthly Avg DMA A",
       x = "Year and Month",
       y = "1-Month Moving Average") +
  scale_x_yearmon(breaks = seq(min(monthly_avg$YearMonth), max(monthly_avg$YearMonth), by = 0.1)) +
  theme_minimal()

df_data_2 <- df_data_1 %>%
  mutate(YearMonth = format(Date, "%Y-%m")) %>%
  group_by(YearMonth) %>%
  summarise(Monthly_Avg_DMA_A = mean(`DMA A`, na.rm = TRUE)) %>%
  ungroup()

# Calculamos las medias móviles para cada uno de los periodos solicitados
# Change the names of the moving averages columns
df_data_2$MA_1 <- rollapply(df_data_2$Monthly_Avg_DMA_A, width = 1, FUN = mean, fill = NA, align = 'right')
df_data_2$MA_5 <- rollapply(df_data_2$Monthly_Avg_DMA_A, width = 2, FUN = mean, fill = NA, align = 'right')
df_data_2$MA_10 <- rollapply(df_data_2$Monthly_Avg_DMA_A, width = 5, FUN = mean, fill = NA, align = 'right')
df_data_2$MA_24 <- rollapply(df_data_2$Monthly_Avg_DMA_A, width = 10, FUN = mean, fill = NA, align = 'right')

# Convert YearMonth back to a date object for visualization
df_data_2$YearMonth <- as.Date(paste0(df_data_2$YearMonth, "-01"))

# Create the plots
p1 <- ggplot(df_data_2, aes(x = YearMonth, y = MA_1)) +
  geom_line() +
  ggtitle("1-Month Moving Average of DMA A")

p5 <- ggplot(df_data_2, aes(x = YearMonth, y = MA_5)) +
  geom_line(color = "blue") +
  ggtitle("5-Month Moving Average of DMA A")

p10 <- ggplot(df_data_2, aes(x = YearMonth, y = MA_10)) +
  geom_line(color = "red") +
  ggtitle("10-Month Moving Average of DMA A")

p24 <- ggplot(df_data_2, aes(x = YearMonth, y = MA_24)) +
  geom_line(color = "green") +
  ggtitle("24-Month Moving Average of DMA A")

# Display the plots
library(gridExtra)
grid.arrange(p1, p5, p10, p24, ncol = 2)



######BONO

data_1 <- df_data_1 %>%
  select(`DMA A`, `DMA B`, `DMA C`, `DMA D`, `DMA E`, `DMA F`, `DMA G`, `DMA H`, `DMA I`, `DMA J`,
         `Rainfall depth (mm)`, `Air temperature (°C)`, `Air humidity (%)`, `Windspeed (km/h)`)


data_2 <- df_data_1 %>%
  select('Date',`DMA A`, `DMA B`, `DMA C`, `DMA D`, `DMA E`, `DMA F`, `DMA G`, `DMA H`, `DMA I`, `DMA J`,
         `Rainfall depth (mm)`, `Air temperature (°C)`, `Air humidity (%)`, `Windspeed (km/h)`)




pca_result <- prcomp(data_1, scale = TRUE)





pca_df <- as.data.frame(pca_result$x)

# Define the number of clusters
k <- 10

# Perform k-means clustering
km_res <- kmeans(pca_df, centers = k, nstart = 25)

# Add cluster assignments to the dataframe
pca_df$cluster <- as.factor(km_res$cluster)

# Plot the results
ggplot(pca_df, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.9) +
  scale_color_brewer(palette = "Set3") +
  labs(title = paste("K-means Clustering with k =", k, "on PCA Components 1 and 2"),
       x = "Principal Component 1 (PC1)",
       y = "Principal Component 2 (PC2)",
       color = "Cluster") +
  theme_minimal()


k <- 10
km_res <- kmeans(pca_df[, c("PC1", "PC2")], centers = k, nstart = 25)

# Add the cluster assignments to your dataframe
pca_df$cluster <- as.factor(km_res$cluster)
library(ggplot2)

# Plot with ggplot2
library(ggplot2)

# Assuming pca_df already has 'cluster' column from k-means clustering
ggplot(pca_df, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(alpha = 0.9) + # Use alpha to adjust point opacity, improving plot readability
  scale_color_brewer(palette = "Set3") + # Use a distinct color palette for clarity
  labs(title = "K-means Clustering with k=10 on PCA Components 1 and 2",
       x = "Principal Component 1 (PC1)",
       y = "Principal Component 2 (PC2)",
       color = "Cluster") + # Correct way to set the legend title
  theme_minimal() # Use a minimal theme for a cleaner look


library(dplyr)


# Assuming 'pca_df' has 'PC1', 'PC2', and 'cluster' columns from previous steps
# Calculate centroids from the kmeans result
centroids <- aggregate(cbind(PC1, PC2) ~ cluster, data = pca_df, FUN = mean)

# Join centroids back to the original data to compute distances
pca_df_with_centroids <- merge(pca_df, centroids, by = "cluster", suffixes = c("", "_centroid"))

# Calculate Euclidean distance from each point to its cluster centroid
pca_df_with_centroids$distance <- sqrt((pca_df_with_centroids$PC1 - pca_df_with_centroids$PC1_centroid)^2 + 
                                       (pca_df_with_centroids$PC2 - pca_df_with_centroids$PC2_centroid)^2)

# Define outlier criterion, e.g., distances greater than 2 standard deviations from the mean distance for each cluster
pca_df_with_centroids <- pca_df_with_centroids %>%
  group_by(cluster) %>%
  mutate(mean_distance = mean(distance), sd_distance = sd(distance)) %>%
  ungroup() %>%
  mutate(outlier = ifelse(distance > mean_distance + 1.5*sd_distance, TRUE, FALSE))

# Filter out outliers
df_no_outliers <- filter(pca_df_with_centroids, outlier == FALSE)

######################Last##############

library(dplyr)
library(kmeans)

# Suponemos que df_data_1 ya está cargado y contiene las variables adecuadas para realizar k-means

# Realizamos el agrupamiento k-means con 10 clusters
set.seed(123) # Establecemos una semilla para reproducibilidad
kmeans_result <- kmeans(df_data_1[, -1], centers = 10) # Asumimos que la primera columna es 'Date' y no la incluimos

# Añadimos la asignación de clusters al dataframe
df_data_1$cluster <- kmeans_result$cluster

# Calculamos los centroides
centroids <- aggregate(. ~ cluster, data = df_data_1, FUN = mean)

# Unimos los centroides al dataframe original
df_data_1 <- merge(df_data_1, centroids, by = "cluster", suffixes = c("", "_centroid"))

# Calculamos la distancia Euclidiana desde cada punto a su centroide
df_data_1$distance <- sqrt(rowSums((df_data_1[, c("PC1", "PC2")] - df_data_1[, c("PC1_centroid", "PC2_centroid")])^2))

# Calculamos la media y la desviación estándar de la distancia para cada cluster
df_data_1 <- df_data_1 %>%
  group_by(cluster) %>%
  mutate(mean_distance = mean(distance), sd_distance = sd(distance)) %>%
  ungroup()

# Definimos los outliers como aquellos puntos que están a más de 1.5 desviaciones estándar de la media
df_data_1$outlier <- ifelse(df_data_1$distance > (df_data_1$mean_distance + 1.5 * df_data_1$sd_distance), TRUE, FALSE)

# Filtramos los outliers
df_no_outliers <- filter(df_data_1, outlier == FALSE)

#######################################################


# Assuming df_no_outliers is already created after filtering out outliers
# Get the row indices (as numeric values)
row_indices <- as.numeric(rownames(df_no_outliers))

# Now you can use these indices to select the same rows from the original dataframe
df_no_Outliers <- data_1[row_indices, ]


df_no_outliers$Date <- as.POSIXct(df_no_outliers$Date, format="%d/%m/%Y %H:%M")
df_no_outliers$Hour <- hour(df_no_outliers$Date)

hourly_averages <- df_no_outliers %>%
  group_by(Hour) %>%
  summarise(Average_DMA_A = mean(`DMA A`, na.rm = TRUE))

# Creamos el gráfico con ggplot2
ggplot(hourly_averages, aes(x = Hour, y = Average_DMA_A)) +
  geom_line() +  # Línea que conecta los puntos medios
  geom_point() +  # Puntos que representan los promedios reales por hora
  labs(title = "Media Móvil por Hora para DMA A", x = "Hora del Día", y = "Media de DMA A") +
  scale_x_continuous(breaks = 0:23) +  # Aseguramos que el eje x tenga las 24 horas
  theme_minimal()  # Tema minimalista para el gráfico






















df_no_outliers$Date <- as.POSIXct(df_no_outliers$Date, format="%d/%m/%Y %H:%M")
df_no_outliers$Hour <- hour(df_no_outliers$Date)

hourly_averages <- df_no_outliers %>%
  group_by(Hour) %>%
  summarise(Average_DMA_A = mean(`DMA A`, na.rm = TRUE))

# Creamos el gráfico con ggplot2
ggplot(hourly_averages, aes(x = Hour, y = Average_DMA_A)) +
  geom_line() +  # Línea que conecta los puntos medios
  geom_point() +  # Puntos que representan los promedios reales por hora
  labs(title = "Media Móvil por Hora para DMA A", x = "Hora del Día", y = "Media de DMA A") +
  scale_x_continuous(breaks = 0:23) +  # Aseguramos que el eje x tenga las 24 horas
  theme_minimal()  # Tema minimalista para el gráfico


row_indices <- as.numeric(rownames(df_no_outliers))

# Now you can use these indices to select the same rows from the original dataframe
df_no_outliers <- data_1[row_indices, ]


df_no_outliers$Date <- as.POSIXct(df_no_outliers$Date, format="%d/%m/%Y %H:%M")
df_no_outliers$Hour <- hour(df_no_outliers$Date)

hourly_averages <- df_no_outliers %>%
  group_by(Hour) %>%
  summarise(Average_DMA_A = mean(`DMA A`, na.rm = TRUE))

# Creamos el gráfico con ggplot2
ggplot(hourly_averages, aes(x = Hour, y = Average_DMA_A)) +
  geom_line() +  # Línea que conecta los puntos medios
  geom_point() +  # Puntos que representan los promedios reales por hora
  labs(title = "Media Móvil por Hora para DMA A", x = "Hora del Día", y = "Media de DMA A") +
  scale_x_continuous(breaks = 0:23) +  # Aseguramos que el eje x tenga las 24 horas
  theme_minimal()  # Tema minimalista para el gráfico







