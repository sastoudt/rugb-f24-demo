#### features ####

top100_2016f <- get_playlist_audio_features(username = "sstoudt", playlist_uris = "37i9dQZF1CyJMsfFrWRs3e", authorization = access_token) ## replace with your info
top100_2017f <- get_playlist_audio_features(username = "sstoudt", "37i9dQZF1E9VMadgBWBz54", authorization = access_token)
top100_2018f <- get_playlist_audio_features(username = "sstoudt", "37i9dQZF1EjgejlROSsKGo", authorization = access_token)
top100_2019f <- get_playlist_audio_features(username = "sstoudt", "37i9dQZF1EteKcFAfmqtzy", authorization = access_token)
top100_2020f <- get_playlist_audio_features(username = "sstoudt", "37i9dQZF1EM3bc1T0nYbgU", authorization = access_token)


## you will want to store these because there are some limits on how often/how much data
## you can pull within a certain time frame

save(top100_2016f, file = "data/top100_2016f.RData")
save(top100_2017f, file = "data/top100_2017f.RData")
save(top100_2018f, file = "data/top100_2018f.RData")
save(top100_2019f, file = "data/top100_2019f.RData")
save(top100_2020f, file = "data/top100_2020f.RData")

#### lyrics ####


artists <- map(top100_2020f$track.artists, ~ .x[1, "name"]) %>% unlist()
track_name <- top100_2020f$track.name

source("helper_code/getLyricsFixes.R")

## makes sure if it errors out on one, it keeps going
safe_lyrics <- safely(get_lyrics_searchF)


# tryThis = get_lyrics_searchF(artist_name = artists[1], song_title = track_name[1])


## takes awhile
lyrics20 <- map2(artists, track_name, safe_lyrics)

## which ones errored out?
didItWork <- map(lyrics20, ~ .x$error)

sum(unlist(map(didItWork, is.null))) ## How many have lyrics 74/100, fine for now

## again, you will want to store these because there are limits
save(lyrics20, file = "data/lyrics20.RData")

