# Importing libraries
library(dplyr)      # For data manipulation
library(ggplot2)    # For data visualization
library(tidyr)      # For data tidying
library(readr)      # For reading data
library(readxl)     # For reading excel files
library(psych)      # For descriptive statistics
library(zoo)        # For handling missing values

#setwd("C:/Users/David/Documents/Analytics/Semester 2/Mineria de Datos/Tarea 1")


# Read weather data
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



library(dplyr)


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

#Remove rows with NA values

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

# Create a data frame with column names and NA proportions
na_summary <- data.frame(
  Column = names(colMeans(is.na(df_data))),
  NA_Proportion = na_proportion
)

na_summary <- na_summary %>%
  arrange(desc(NA_Proportion))

# Print the summary
print(na_summary)

#Primer analisis eliminar na

df_data_1<-na.omit(df_data)


# Select numeric columns from the data frame
numeric_cols <- sapply(df_data_1, is.numeric)

# Iterate over numeric columns and plot histograms
par(mfrow=c(ceiling(sqrt(sum(numeric_cols))), ceiling(sqrt(sum(numeric_cols)))))  # Set up multiple plot layout
for(col in names(df_data_1)[numeric_cols]) {
  hist(df_data_1[[col]], main = paste("Histogram of", col),
       xlab = col, ylab = "Frequency")
}


######################1################################

# Select only numeric columns
numeric_df <- df_data_1 %>%
  select_if(is.numeric)

# Perform PCA on numeric data
pca_result <- prcomp(numeric_df, scale. = TRUE)

# Reconstruct data
reconstructed_data <- pca_result$rotation %*% t(pca_result$x)

# Calculate residuals
residuals <- numeric_df - t(reconstructed_data)

# Identify outliers using Mahalanobis distance
mahalanobis_dist <- sqrt(rowSums(residuals^2))
cutoff <- mean(mahalanobis_dist) + 2 * sd(mahalanobis_dist)  # Adjust threshold as needed
outliers <- which(mahalanobis_dist > cutoff)

# Display outliers
print(outliers)



pca_df <- as.data.frame(pca_result$x)  # Use principal components as dataframe

# Add a column to mark outliers
pca_df$outlier <- ifelse(rownames(pca_df) %in% outliers, "Outlier", "Normal")

# Scatter Plot of Principal Components
scatter_plot_pca <- ggplot(data = pca_df, aes(x = PC1, y = PC2, color = outlier)) +
  geom_point() +
  labs(x = "Principal Component 1", y = "Principal Component 2", title = "Scatter Plot of Principal Components (PC1 vs. PC2)")

# Display the plot
scatter_plot_pca


# Load required libraries
library(stats)

# Perform k-means clustering on numeric data
k <- 5  # Specify the number of clusters
kmeans_result <- kmeans(numeric_df, centers = k)

# Identify outliers
cluster_centers <- kmeans_result$centers
cluster_indices <- kmeans_result$cluster

# Calculate Euclidean distance from each point to its cluster center
distances <- sqrt(rowSums((numeric_df - cluster_centers[cluster_indices,])^2))

# Set threshold for identifying outliers
cutoff <- quantile(distances, 0.95)  # Adjust threshold as needed

# Identify outliers based on distance from cluster centers
outliers_kmeans <- which(distances > cutoff)

# Display outliers
print(outliers_kmeans)


# Perform PCA on numeric data
pca_result <- prcomp(numeric_df, scale. = TRUE)

# Get the principal components
pc1 <- pca_result$x[, 1]
pc2 <- pca_result$x[, 2]

# Create a data frame with principal components and cluster labels
cluster_df <- data.frame(PC1 = pc1, PC2 = pc2, Cluster = as.factor(kmeans_result$cluster))

# Plot clusters in a scatter plot
ggplot(data = cluster_df, aes(x = PC1, y = PC2, color = Cluster)) +
  geom_point() +
  labs(x = "Principal Component 1", y = "Principal Component 2", title = "Clusters in Two Dimensions")






# Perform PCA on numeric data
pca_result <- prcomp(numeric_df, scale. = TRUE,n.comp = 4)

# Extract the explained variance for the first two principal components
explained_variance <- pca_result$sdev^2

# Calculate the total variance
total_variance <- sum(explained_variance)

# Calculate the explained variance ratio
explained_variance_ratio <- explained_variance / total_variance

# Print the explained variance ratio for the first two principal components
print(explained_variance_ratio)

# Plot the data points in a scatter plot including PC3 and PC4
library(ggplot2)

# Assuming pca_df already contains PCA results and a logical vector 'outliers' identifying outliers.
# 'cutoff' is used to determine outliers based on Mahalanobis distance, which should be calculated beforehand.

# Basic scatter plot for PC2 vs. PC3 with color and shape coding for Normal vs. Outlier
ggplot(data = pca_df, aes(x = PC1, y = PC2)) +
  geom_point(aes(color = factor(ifelse(mahalanobis_dist > cutoff, "Outlier", "Normal")),
                 shape = factor(ifelse(mahalanobis_dist > cutoff, "Outlier", "Normal")))) +
  labs(x = "Principal Component 2", y = "Principal Component 3",
       title = "PCA with 4 Components and Outlier Detection") +
  scale_color_manual(values = c("Normal" = "blue", "Outlier" = "red")) +
  scale_shape_manual(values = c("Normal" = 16, "Outlier" = 17)) +
  theme(legend.position = "bottom")


ggplot(pca_df, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point() +
  labs(title = "K-means Clustering on PCA Components",
       x = "Principal Component 2",
       y = "Principal Component 3") +
  scale_color_brewer(palette = "Set1") +
  theme_minimal()


  library(stats) # For kmeans

# Assuming pca_df is your dataframe with columns for PC2 and PC3
data <- pca_df[, c("PC2", "PC3")]

# Define the range of k values to try
k.max <- 10 # Maximum number of clusters to consider
wss <- numeric(k.max)

# Calculate WSS for each k
for (k in 1:k.max) {
  wss[k] <- sum(kmeans(data, centers = k, nstart = 20)$withinss)
}



library(ggplot2)

k_values <- 1:20  # the range of k you tested
ggplot(data.frame(k = k_values, WSS = wss), aes(x = k, y = WSS)) +
  geom_point() +
  geom_line() +
  labs(title = "Elbow Method for Choosing k",
       x = "Number of clusters k",
       y = "Total within-cluster sum of squares") +
  theme_minimal()


library(stats) # For kmeans
set.seed(123) # Ensure reproducibility

# Assuming pca_df is your dataframe and it has columns named PC1, PC2
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
  mutate(outlier = ifelse(distance > mean_distance + 2*sd_distance, TRUE, FALSE))

# Filter out outliers
pca_df_no_outliers <- filter(pca_df_with_centroids, outlier == FALSE)

# Punto2

df_data_1 <- df_data_1[order(df_data_1$Date), ]




library(dplyr)
library(lubridate)

# Asegurando que 'Date' es de tipo fecha y hora
df_data_1$Date <- as.POSIXct(df_data_1$Date, format="%d/%m/%Y %H:%M")

# Crear nuevas columnas basadas en la fecha
df_data_1 <- df_data_1 %>%
  mutate(
    Seconds = second(Date),
    Minutes = minute(Date),
    Hours = hour(Date),
    DayOfWeek = wday(Date, label = TRUE), # Esto te dará el día de la semana
    Day = day(Date),
    Week = week(Date),
    Month = month(Date, label = TRUE), # Esto te dará el mes como un valor categórico
    Year = year(Date)
  )

# Ahora df_data_1 tiene columnas adicionales para segundos, minutos, horas, etc.


library(zoo)
library(dplyr)

# Asumiendo que 'df_data_1' ya tiene las columnas 'Seconds', 'Minutes', 'Hours', 'Day', 'Week', 'Month' añadidas

# Asegúrate de tener las librerías necesarias
library(dplyr)
library(lubridate)
library(ggplot2)

# Añadir columnas de año-semana y año-mes para agrupamiento
df_data_1 <- df_data_1 %>%
  mutate(
    YearWeek = paste(year(Date), sprintf("%02d", week(Date)), sep = "-"),
    YearMonth = paste(year(Date), sprintf("%02d", month(Date)), sep = "-")
  )

# Calcular la media semanal para "DMA A"
df_weekly <- df_data_1 %>%
  group_by(YearWeek) %>%
  summarise(Weekly_Avg = mean(`DMA A`, na.rm = TRUE)) %>%
  ungroup() # Retira el agrupamiento para facilitar la graficación

# Calcular la media mensual para "DMA A"
df_monthly <- df_data_1 %>%
  group_by(YearMonth) %>%
  summarise(Monthly_Avg = mean(`DMA A`, na.rm = TRUE)) %>%
  ungroup() # Retira el agrupamiento para facilitar la graficación


ggplot(df_monthly, aes(x = YearMonth, y = Monthly_Avg, group = 1)) +
  geom_line() +
  theme_minimal() +
  labs(title = "Media Móvil Mensual para DMA A", x = "Año-Mes", y = "Promedio Mensual") +
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))
