## Live Coding - Day 1D

library(tidyverse)
library(tidymodels)
library(readr)

# Data Preparation
titanic <- 
  read_csv("https://tinyurl.com/titanic-pm") %>% 
  mutate(
    survived = factor(survived),
    pclass = factor(pclass),
    sex = factor(sex)
  ) %>% 
  na.omit()

# Split Data 
titanic_split <- initial_split(titanic, prop = 0.8, strata = 'survived')
titanic_train <- training(titanic_split)
titanic_test <- testing(titanic_split)

# Specify Model 
log_reg <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")
log_reg

# Fit Model of Training Data
survived_fit <- log_reg %>%
  fit(survived ~ ., data = titanic_train)

# Inspect Model 
tidy(survived_fit)

# Make Predictions on Test Set 
survived_test_preds <- predict(survived_fit, new_data = titanic_test)
survived_test_preds

# Merge Predictions with the Test Data 
survived_preds <- titanic_test %>% 
  select(survived) %>% 
  bind_cols(survived_test_preds)
survived_preds

# Make confusion matrix
conf_mat(data = survived_preds, 
         truth = survived,
         estimate = .pred_class)
survived_cm <- conf_mat(data = survived_preds, 
                        truth = survived,
                        estimate = .pred_class)
autoplot(survived_cm)
