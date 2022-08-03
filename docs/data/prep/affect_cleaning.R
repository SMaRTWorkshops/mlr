data(affect)

affect_df <- affect %>% select(Film, ext, neur, imp, soc, PA2, NA2, BDI) %>%
  mutate(Film = factor(Film, labels = c("Documentary", "Horror", "Nature", "Comedy"))) %>% 
  rename(posaff = PA2, negaff = NA2)

summary(affect_df)

write.csv(affect_df, "../data/affect.csv", row.names = FALSE)
