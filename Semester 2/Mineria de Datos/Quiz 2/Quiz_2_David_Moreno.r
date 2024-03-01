
setwd("C:/Users/David/Documents/Analytics/Semester 2/Mineria de Datos/Quiz 2")


#import the necessary libraries for data manipulation and visualization
library(tidyverse)
library(ggplot2)
library(tidyr) 
# Import the library for Generalized Additive Models
library(mgcv)



load("auto.Rdata")
load("wage.Rdata")

head(Wage)





#plot Wage against jobclass
ggplot(Wage, aes(x = jobclass, y = wage)) + 
  geom_boxplot() + 
  labs(title = "Wage vs Jobclass", x = "Jobclass", y = "Wage") + 
  theme_minimal()



#plot Wage against jobclass
ggplot(Wage, aes(x = maritl, y = wage)) + 
  geom_boxplot() + 
  labs(title = "Wage vs Jobclass", x = "Jobclass", y = "Wage") + 
  theme_minimal()



# Gráfico de los efectos de 'maritl' sobre 'wage'
ggplot(Wage, aes(x = maritl, y = predicted_wage)) +
  geom_boxplot() +
  labs(title = "Efectos de Maritl sobre Wage (Modelo GAM)", x = "Estado Civil", y = "Salario Predicho") +
  theme_minimal()


# Fit a GAM model using cubic spline smoothing for maritl with an appropriate k value
# Replace K with the appropriate number based on the unique values of maritl
# Typically, k should be the number of unique values of 'maritl' plus 1 at most

# # Find out how many unique levels there are
# num_levels <- length(unique(Wage$maritl))

# # Now fit the model with an appropriate k (k = num_levels is usually sufficient for categorical variables)
# model_maritl_cs <- gam(wage ~ s(maritl, bs = "cs", k = num_levels), data = Wage)

# # Summary of the new model
# summary(model_maritl_cs)



Wage_regression <- Wage %>% select(jobclass, wage, age, maritl)


#do a one hot encoding for the maritl variable
one_hot_maritl <- model.matrix(~0+maritl, data = Wage)
one_hot_jobclass <- model.matrix(~0+jobclass, data = Wage)


Wage_regression <- cbind(Wage_regression, one_hot_maritl, one_hot_jobclass)

# Rename columns according to their positions
colnames(Wage_regression) <- c("jobclass", "wage", "age", "maritl", "Never_Married", "Married", "Widowed", "Divorced", "Separated", "Industrial", "Information")



regression_model <- lm(wage ~ age + Never_Married + Married + Widowed + Divorced + Separated + Industrial + Information, data = Wage_regression)
summary(regression_model)




model_maritl_fs <- gam(wage ~ s(maritl, bs = "fs") + s(jobclass, bs = "fs") + s(age, bs = "cs"), data = Wage_regression)
summary(model_maritl_fs)




# Assuming model_maritl_fs is already fitted and Wage_regression is your data frame

# Predict the wage using the model for all observations
Wage_regression$predicted_wage <- predict(model_maritl_fs, type = "response")

# Aggregate to see the mean predicted wage for each combination of jobclass and maritl
mean_predicted_wage_per_jobclass_maritl <- Wage_regression %>%
  dplyr::group_by(jobclass, maritl) %>%
  dplyr::summarise(MeanPredictedWage = mean(predicted_wage))

# Print the mean predicted wage for each combination of jobclass and maritl
print(mean_predicted_wage_per_jobclass_maritl)


library(ggplot2)

# Assuming Wage_regression already contains the actual 'wage' and predicted 'predicted_wage'
Wage_regression$actual_wage <- Wage_regression$wage  # Ensure this column exists

# Create a new data frame that stacks the actual and predicted wages with an indicator
Wage_combined <- rbind(
  data.frame(wage = Wage_regression$actual_wage, type = 'Actual'),
  data.frame(wage = Wage_regression$predicted_wage, type = 'Predicted')
)



# Fit the GAM model with cubic splines for age and factor smooths for maritl and jobclass
model_maritl_fs <- gam(wage ~ s(maritl, bs = "fs") + 
                              s(jobclass, bs = "fs") + 
                              s(age, bs = "cs"),  # Using cubic splines for age
                        data = Wage_regression)

# Generate predicted values from the model
Wage_regression$predicted_wage <- predict(model_maritl_fs, type = "response")

# Create a scatter plot to compare actual and predicted wage values
ggplot(Wage_regression, aes(x = wage, y = predicted_wage)) +
  geom_point(aes(color = "Actual"), alpha = 0.5) +
  geom_point(aes(x = predicted_wage, y = predicted_wage, color = "Predicted"), alpha = 0.5) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  scale_color_manual(values = c("Actual" = "blue", "Predicted" = "#f31111")) +
  labs(title = "Actual vs Predicted Wage",
       x = "Actual Wage",
       y = "Predicted Wage") +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5))  # Center the plot title




## Punto 2

# Cargar librerías
library(GGally)

# Cargar el conjunto de datos
load("auto.Rdata")

# Crear la matriz de gráficos de dispersión
ggpairs(Auto[, 1:8])  # Seleccionar solo las primeras 8 columnas ya que 'name' es categórica y no sería útil en una matriz de gráficos de dispersión


colnames(Auto)