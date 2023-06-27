library(tidyverse)

set.seed(2022)
water <- 
  read_csv("./data/prep/water_raw.csv") %>% 
  as_tibble() %>% 
  drop_na() %>% 
  sample_frac(1) %>% 
  print()

write_csv(water, file = "./data/water.csv")
