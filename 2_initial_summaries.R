#### get organized ####

load(file = "data/top100_2016f.RData")
load(file = "data/top100_2017f.RData")
load(file = "data/top100_2018f.RData")
load(file = "data/top100_2019f.RData")
load(file = "data/top100_2020f.RData")



top100_2016f$listYear <- rep(2016, 101)
top100_2017f$listYear <- rep(2017, 100)
top100_2018f$listYear <- rep(2018, 100)
top100_2019f$listYear <- rep(2019, 100)
top100_2020f$listYear <- rep(2020, 100)


all <- rbind.data.frame(
  top100_2016f, top100_2017f, top100_2018f, top100_2019f, top100_2020f
)



all$releaseYear <- str_sub(all$track.album.release_date, 1, 4) ## get the year

all$primaryArtist <- map(all$track.artists, ~ .x[1, "name"]) %>% unlist()
## just pick the primary artist to make things easier


#### plots ####
ggplot(all, aes(track.duration_ms)) +
  geom_histogram() +
  facet_wrap(~listYear) +
  theme_minimal()

## More info on the popularity metric
## https://www.artist.tools/features/spotify-popularity-index

ggplot(all, aes(track.popularity)) +
  geom_histogram() +
  facet_wrap(~listYear) +
  theme_minimal()

ggplot(all, aes(releaseYear)) +
  geom_histogram(stat = "count") +
  facet_wrap(~listYear) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1))


#### tables ####
all %>%
  arrange(releaseYear) %>%
  select(track.name, primaryArtist) %>%
  head(10) ## oldest songs


all %>%
  group_by(primaryArtist, track.name) %>%
  summarize(count = n()) %>%
  arrange(desc(count)) %>%
  as.data.frame() %>%
  head(15) ## repeats of songs across years


all %>%
  group_by(primaryArtist) %>%
  summarize(count = n()) %>%
  arrange(desc(count)) %>%
  as.data.frame() %>%
  head(25) ## repeats of artists across years
