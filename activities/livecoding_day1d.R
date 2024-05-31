## library 
library(tidyverse)
library(tidymodels)
library(readr)
library(vip)


# data 
titanic <- 
  read_csv("https://tinyurl.com/mlr-titanic") %>% 
  mutate(
    survived = factor(survived),
    pclass = factor(pclass),
    sex = factor(sex)
  ) %>% 
  na.omit()


# view
head(titanic)


# split data 
titanic_split <- initial_split(titanic, prop = 0.8, strata = 'survived')
titanic_train <- training(titanic_split)
titanic_test <- testing(titanic_split)


# parsnip step 1: specify model
log_reg <- logistic_reg() %>%
  set_engine("glm") %>% 
  set_mode("classification")

log_reg


# parsnip step 2: fit model on training data set
survived_fit <- log_reg %>% 
  fit(survived ~ fare + age + sibsp, data = titanic_train)

survived_fit


# parsnip step 3: inspect results 
tidy(survived_fit)
vip(survived_fit)


# parsnip step 4: making predictions on the test set 
survived_test_preds <- predict(survived_fit, new_data = titanic_test)
survived_test_preds

# merge the predictions with test data
survived_preds <- titanic_test %>% 
  select(survived) %>% 
  bind_cols(survived_test_preds)
survived_preds

# comparing predicted to actual values (ground truth)
survived_cm <- conf_mat(data = survived_preds, truth = survived, estimate = .pred_class)

autoplot(survived_cm, type = "mosaic")
autoplot(survived_cm, type = "heatmap")

