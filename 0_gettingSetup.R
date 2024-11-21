#### R operations ####

install.packages("tidyverse") ## just do once

library(tidyverse)

install.packages("scales") ## just do once

library(scales)


#### access to Spotify data ####

install.packages("spotifyr") ## just do once

library(spotifyr)

## You will need a Spotify account if you don't already have one.
## A free account is fine for the purposes of this activity.

## Log into the developer dashboard using your Spotify account
## https://developer.spotify.com/dashboard

## Create an app (select "Web API" when prompted)
## More info here: https://developer.spotify.com/documentation/web-api

## You can use the following as the redirect URI when prompted
## https://example.com/callback


## replace with your own
## WARNING: don't post this info online anywhere
spotify_client_id <- "" ## under Settings --> Basic Information
spotify_client_secret <- "" ## under Settings --> Basic Information --> View client secret

## store this info as an access token object
access_token <- get_spotify_access_token(client_id = spotify_client_id, client_secret = spotify_client_secret)

## or store those values to your personal R environment
Sys.setenv(SPOTIFY_CLIENT_ID = spotify_client_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = spotify_client_secret)



#### access to Genius (lyrics) data ####

install.packages("geniusr") ## just do once

library(geniusr)

install.packages("rvest") ## just do once

library(rvest)

install.packages("xml2") ## just do once

library(xml2)

## You will need to a Genius account if you don't already have one.
## https://docs.genius.com/

## Log into your Genius account
## https://genius.com/api-clients

## Create a new API client.
## You can use the following as the redirect URI when prompted
## http://example.com

genius_token() ## this will prompt you for your info
## (client access token)
