## Live Coding - Day 1C

library(tidyverse)
library(tidymodels)

# Load in Data 

titanic <- read_csv("https://rb.gy/hm7p84")

# mutate categorical variables to factor
titanic <- titanic %>% 
  mutate(survived = factor(survived), 
         sex = factor(sex), 
         pclass = factor(pclass))

# view
head(titanic)

# set random seed so results are reproducible
set.seed(2022) 

# create and save an 80/20 data split
titanic_split_simple <- initial_split(data = titanic, prop = 0.80)
titanic_split_simple

titanic_train_simple <- training(titanic_split_simple)
titanic_test_simple <- testing(titanic_split_simple)

dim(titanic_train_simple)
dim(titanic_test_simple)

set.seed(2022)

titanic_split_strat <- initial_split(data = titanic, prop = 0.8, strata = 'survived')
titanic_train_strat <- training(titanic_split_strat)
titanic_test_strat <- testing(titanic_split_strat)