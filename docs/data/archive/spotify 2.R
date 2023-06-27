# Dataset information:

# https://www.kaggle.com/datasets/yasserh/song-popularity-dataset
# https://www.kaggle.com/datasets/yasserh/song-popularity-dataset/discussion/331001
# https://developer.spotify.com/documentation/web-api/reference/#/operations/get-several-audio-features

library(tidyverse)

set.seed(2022)

spotify <- 
  read_csv("./data/prep/spotify_raw.csv", col_types = "cdddddddddddddd") |> 
  distinct() |> 
  sample_n(size = 5000, replace = FALSE) |> 
  transmute(
    popularity = song_popularity,
    duration = song_duration_ms / 1000,
    acousticness,
    danceability,
    energy,
    instrumentalness,
    key = na_if(key, -1),
    liveness,
    loudness,
    mode = if_else(audio_mode == 0, "minor", "major"),
    speechiness,
    tempo,
    time_signature,
    valence = audio_valence,
    title = song_name
  ) |> 
  arrange(title)

write_csv(spotify, "./data/spotify.csv")
