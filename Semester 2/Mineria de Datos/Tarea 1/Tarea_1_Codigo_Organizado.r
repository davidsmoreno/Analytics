library(dplyr)      # For data manipulation
library(ggplot2)    # For data visualization
library(tidyr)      # For data tidying
library(readr)      # For reading data
library(readxl)     # For reading excel files
library(psych)      # For descriptive statistics
library(zoo)        # For handling missing values

# Read Inflow Data
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



#2
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


#3
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



#Primer analisis eliminar NA
df_data_1<-na.omit(df_data)


# Identify numeric columns. This is a placeholder; replace it with your actual logic to identify numeric columns
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



#4

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



df_data_3 <- df_data_1 %>%
  mutate(Year = year(Date),
         Month = month(Date),
         YearMonth = as.yearmon(Date))

# Group by year and month to calculate the monthly average of DMA A
monthly_avg <- df_data_3 %>%
  group_by(YearMonth) %>%
  summarise(MonthlyAvg_DMA_A = mean(`DMA A`, na.rm = TRUE))

# Calculate the one-month moving average for the monthly averages of DMA A
monthly_avg$MovingAvg_1M <- rollapply(monthly_avg$MonthlyAvg_DMA_A, width = 1, FUN = mean, by.column = TRUE, fill = NA, align = 'right')

# Visualization with ggplot2

ggplot(monthly_avg, aes(x = YearMonth, y = MovingAvg_1M)) +
  geom_line() +
  geom_point() +
  labs(title = "1-Month Moving Average of Monthly Avg DMA A",
       x = "Year and Month",
       y = "1-Month Moving Average") +
  scale_x_yearmon(breaks = seq(min(monthly_avg$YearMonth), max(monthly_avg$YearMonth), by = 0.1)) +
  theme_minimal()


#6

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


