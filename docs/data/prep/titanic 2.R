library(farff)
library(tidyverse)

# https://www.openml.org/search?type=data&sort=runs&id=40945&status=active

titanic <- 
  readARFF("./data/prep/titanic.arff") |> 
  as_tibble() |> 
  select(
    survived,
    fare,
    pclass,
    sex,
    age,
    sibsp,
    parch
  ) |> 
  print()

write_csv(titanic, file = "./data/titanic.csv")
