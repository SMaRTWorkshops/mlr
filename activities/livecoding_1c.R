## Live Coding  - Day 1C

library(tidyverse)
library(tidymodels)
library(readr)

## Load in Data
titanic <- read_csv("https://tinyurl.com/titanic-pm")

# Data Preparation 
titanic <- titanic %>% 
  mutate(survived = factor(survived),
         sex = factor(sex),
         pclass = factor(pclass))
head(titanic)

# set random seed 
set.seed(2022)

# create simple random split 
titanic_split_simple <- initial_split(data = titanic, prop = 0.80)
titanic_split_simple

# create training and testing datasets
titanic_train_simple <- training(titanic_split_simple)
titanic_test_simple <- testing(titanic_split_simple)
head(titanic_train_simple)

# create a stratified random split 
titanic_split_strat <- initial_split(data = titanic, prop = 0.80, 
                                     strata = 'survived')

titanic_split_strat

# training and testing datasets
titanic_train_strat <- training(titanic_split_strat)
titanic_test_strat <- testing(titanic_split_strat)
