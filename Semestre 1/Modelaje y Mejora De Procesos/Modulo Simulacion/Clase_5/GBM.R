#################################################
# 
# Simulacion de proceso de Wiener
# 1 path
if (!require("tidyverse")){install.packages("tidyverse");library(tidyverse)}else{library(tidyverse)}
n = 252
T = 1
dt = T/n
tiempo <- seq(0, T, dt)

dz <- rnorm(n)*sqrt(dt)
z <- cumsum(dz)
z <- c(0, z)

plot(tiempo, z, t = "l")

# Simulaciones de proceso de Wiener
# R paths
R = 1000
n = 252
T = 1
dt = T/n
tiempo <- seq(0, T, dt)

dz <- matrix(rnorm(R*n),R)*sqrt(dt)
z <- apply(dz, 1, cumsum)
z <- rbind(0, z)
matplot(tiempo, z, col = "gray", t = "l")


###########################
# Simulacion de trayectorias del movimiento browniano geometrico (GBM)
# paths
R <- 1000
T <- 1
n <- 252
dt <- T/n

S <- 100
mu <- 0.15
sigma <- 0.30

GBM <- matrix(ncol = R, nrow = n)

for (r in 1:R) {
  GBM[1,r] <- S
  for (day in 2:n) {
    epsilon <- rnorm(1)
    GBM[day, r] <- GBM[(day-1), r] + mu*GBM[(day-1), r]*dt + sigma*GBM[(day-1), r]*epsilon*sqrt(dt)
  }
}

####################
# https://robotwealth.com/
library(tidyverse)

gbm_df <- as.data.frame(GBM) %>%
  mutate(ix = 1:nrow(GBM)) %>%
  pivot_longer(-ix, names_to = 'sim', values_to = 'price')

View(gbm_df)
gbm_df %>%
  ggplot(aes(x=ix, y=price, color=sim)) +
  geom_line() +
  theme(legend.position = 'none')
