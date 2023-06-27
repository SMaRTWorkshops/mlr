## Live Coding - Day 1D

library(tidyverse)
library(tidymodels)
library(readr)
library(vip)

# Data Loading & Preparation
titanic <-
  read_csv("https://tinyurl.com/titanic-pm") %>%
  mutate(
    survived = factor(survived),
    pclass = factor(pclass),
    sex = factor(sex)
  ) %>%
  na.omit()

# view
head(titanic)

# Split Data (1C)
titanic_split <- initial_split(titanic, prop = 0.8, strata = "survived")
titanic_train <- training(titanic_split)
titanic_test <- testing(titanic_split)

# Specify Model (1D)
log_reg <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

log_reg

# Fit Model on Training Data
survived_fit <- log_reg %>% 
  fit(survived ~ ., data = titanic_train)

survived_fit

# Inspect Results with Parsnip
tidy(survived_fit)
vip(survived_fit)

# Make Predictions on Test Set 
survived_test_preds <- predict(survived_fit, new_data = titanic_test)
survived_test_preds

# Merge Predictions with Test Data 
survived_preds <- titanic_test %>% 
  select(survived) %>% 
  bind_cols(survived_test_preds)
survived_preds

augment(survived_fit, new_data = titanic_test)

# Compare Predicted to Actual Values 
survived_cm <- conf_mat(data = survived_preds, truth = survived, estimate = .pred_class)

# Plot Confusion Matrix
autoplot(survived_cm, type = "mosaic")
autoplot(survived_cm, type = "heatmap")

# Classification Metrics
summary(survived_cm)


