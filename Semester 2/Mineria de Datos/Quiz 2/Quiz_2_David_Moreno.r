
#import the necessary libraries for data manipulation and visualization
library(tidyverse)
library(ggplot2)
library(tidyr) 


load("auto.Rdata")
load("wage.Rdata")

head(Wage)



#Punto 1

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

# Ensure necessary libraries are loaded
library(ggplot2)
library(mgcv) # for GAM

# Load your datasets
# Assuming they are already loaded as per your initial script

# Convert `maritl` into a factor if it's not already
Wage$maritl <- as.factor(Wage$maritl)

# Fit a GAM model using `maritl` as a factor for non-linear effects
# Note: `s()` is used for smoothing; `bs="re"` specifies a random effect basis, but for factors, you might not need `bs="re"`
# If maritl is a factor, you might use it directly or explore other smoothing functions
model_maritl <- gam(wage ~ s(maritl, bs = "cs"), data = Wage)

# Plot the partial effects of `maritl` on `wage`
plot(model_maritl, pages = 1)

# Note: The `bs = "cs"` option is used for categorical smoothing. If `maritl` is strictly a categorical variable,
# you might want to adjust this based on your specific analysis needs. 
# The example above assumes you're interested in capturing non-linear trends across different levels of `maritl`.
