#Import the librararies for the SVM
library(e1071)


set.seed(1234)

x<-matrix(rnorm(20*2), ncol=2)
y<-c(rep(-1,10), rep(1,10))

x[y==1,] <- x[y==1,] + 1

plot(x, col=(3-y))