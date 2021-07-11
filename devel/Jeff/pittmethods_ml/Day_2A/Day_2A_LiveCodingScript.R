# Quickly explain RProjects, RNotebooks, and code chunks

# Load packages
library(tidyverse)
library(skimr)
library(caret)
library(recipes)

# Import data (including missing values)
airsat <- read_csv("Day_2A/airsatisfaction.csv")

# Set character variables to factors
airsat <- airsat %>% mutate(across(where(is.character), factor))

# View data
glimpse(airsat)

# Create training and testing sets
set.seed(2021)
index <- createDataPartition(airsat$satisfaction, p = 0.8, list = FALSE)
airsat_train <- airsat[index, ]
airsat_test <- airsat[-index, ]

# Examine size of train and test sets
dim(airsat_train)
dim(airsat_test)

# Exploratory Analysis
skim(airsat_train)

# Create and prep recipe
airsat_recipe <- 
  airsat %>% 
  recipe(satisfaction ~ .) %>% 
  step_nzv(all_predictors()) %>% 
  step_lincomb(all_numeric_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_pca(all_numeric_predictors(), threshold = 0.9) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  prep(training = airsat_train, log_changes = TRUE)

# Bake New Training
airsat_baked_train <- bake(airsat_recipe, new_data = airsat_train)
glimpse(airsat_baked_train)

# Bake New Testing
airsat_baked_test <- bake(airsat_recipe, new_data = airsat_test)
glimpse(airsat_baked_test)
