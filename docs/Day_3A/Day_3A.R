## Day 2B: Regularized Regression 

##---- Packages ----
if (!require("glmnet")) {install.packages("glmnet"); require("glmnet")}     
if (!require("glmnet")) {install.packages("glmnet"); require("glmnet")}     
if (!require("glmnet")) {install.packages("glmnet"); require("glmnet")}     

##---- Data ----

set.seed(2021)
emptyCorMat <- diag(x = 1, nrow= 20, ncol=20, names = TRUE)
emptyCorMat[1,2] <- .8

correlated_relationship <- rnorm(n = 25, mean = .8, sd = .1)
correlated_relationship[correlated_relationship > 1] <- .67
emptyCorMat[3:7, 3:7] <- correlated_relationship

uncorrelated_relationship <- rnorm(n = 50, mean = 0, sd = .05)
uncorrelated_relationship[uncorrelated_relationship > 1] <- .1
emptyCorMat[3:12, 8:12] <- uncorrelated_relationship

no_relationship <- rnorm(n = 8*20, mean = 0, sd = .02)
emptyCorMat[,13:20] <- no_relationship

firstRowCor <- rnorm(n = 10, mean = .8, sd = .2)
firstRowCor[firstRowCor>1] <- .82
emptyCorMat[1,3:12] <- firstRowCor

secondRowCor <- rnorm(n = 10, mean = .8, sd = .2)
secondRowCor[secondRowCor>1] <- .76
emptyCorMat[2,3:12] <- secondRowCor

lowerTriangle(emptyCorMat) = upperTriangle(emptyCorMat, byrow=TRUE)

diag(emptyCorMat) <- 1

stddev <- abs(rnorm(20, mean = 1, sd = 0.5))
covMat <- stddev %*% t(stddev) * emptyCorMat

mu <- rnorm(20, mean = 4, sd = 1)
nn <- corpcor::make.positive.definite(covMat)
dat1 <- mvrnorm(n = 500, mu = mu, Sigma = nn, empirical = FALSE)

# nonlinearities -- for decision trees later
indices <- dat1[,20] < mean(dat1[,20])
indices_length <- length(dat1[indices, 1])
newNumbersToAdd <- rnorm(n=indices_length, mean =3, sd = .3)
dat1[indices, 1] <- dat1[indices, 1] + newNumbersToAdd
dat1[indices, 2] <- dat1[indices, 2] + (newNumbersToAdd * rnorm(n = indices_length, mean = 1, sd = .3))

dat1[,2] <- dplyr::case_when(
  dat1[,2] <= mean(dat1[,2])~ 0,
  TRUE ~ 1) 

for (i in 1:ncol(dat1)){
  if (min(dat1[, i]) < 0) {
    dat1[, 1] <- dat1[, 1] + min(dat1[, i])
  }
}

cor(as.data.frame(dat1))

EDsim <- as.data.frame(dat1)
varnames <- c("ED_severity", "ED_diagnosis", 
              "emo_reg", "depression", "impulsivity", "self_crit", "anxiety",
              "race", "age", "SES", "prior_treatment", "perfectionism",
              "day_temperature", "rainfall", "num_siblings", "num_cellphones", "time_news", "time_tv", "num_pets",
              "treatment_length")
names(EDsim) <- varnames
EDsim <- EDsim %>% mutate(ED_diagnosis = factor(ED_diagnosis, labels = c("no_ED", "ED")), race = as.factor(floor(race)), age = age + 14, SES = as.factor(floor(SES)), num_siblings = floor(num_siblings), num_cellphones = floor(num_cellphones), num_pets = floor(num_pets))