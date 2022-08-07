library(tidyverse)

water <- 
  read_csv("./data/prep/water_raw.csv") %>% 
  as_tibble() %>% 
  drop_na() %>% 
  print()

write_csv(water, file = "./data/water.csv")
