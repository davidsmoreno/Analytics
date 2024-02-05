#################################################

rm(list=ls())
if (!require("quantmod")){install.packages("quantmod");library(quantmod)}else{library(quantmod)}
if (!require("tidyverse")){install.packages("tidyverse");library(tidyverse)}else{library(tidyverse)}

########
## Alpha & Sigma

getSymbols("AAPL", from = "2010-01-01")
rets = dailyReturn(AAPL$AAPL.Adjusted,type="log")
sigma = sd(rets)*sqrt(252)
print(sigma)
alpha <- mean(rets)*252 + 1/2*sigma^2
print(alpha)

# Simulaci?n de trayectorias del movimiento browniano geom?trico (GBM)

S <- getQuote("AAPL")$Last

R <- 10000
T <- 1
n <- 252
dt <- T/n

GBM <- matrix(ncol = R, nrow = n)

for (r in 1:R) {
  GBM[1,r] <- S
  for (day in 2:n) {
    epsilon <- rnorm(1)
    GBM[day, r] <- GBM[(day-1), r]*exp((alpha-1/2*sigma^2)*dt + sigma*epsilon*sqrt(dt))
  }
}

hist(GBM[252,])

quantile(GBM[252,], prob=c(0.05,0.50,0.95))

####################
gbm_df <- as.data.frame(GBM) %>%
  mutate(ix = 1:nrow(GBM)) %>%
  pivot_longer(-ix, names_to = 'sim', values_to = 'price')


gbm_df %>%
  ggplot(aes(x=ix, y=price, color=sim)) +
  geom_line() +
  theme(legend.position = 'none')
