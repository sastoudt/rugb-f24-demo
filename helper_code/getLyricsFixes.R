## package source code
bad_lyric_strings <- c(
  "\\s*\\(Ft.[^\\)]+\\)" = "",
  "&" = "and",
  "\\$" = " ",
  "'" = "",
  # "\u00e9" = "e",
  # "\u00f6" = "o",
  "[[:punct:]]" = "",
  "[[:blank:]]+" = " ",
  " " = "-"
)

## package source code tweaked to avoid bug
get_lyrics_searchF <- function(artist_name, song_title) {
  artist_nameOld <- artist_name
  artist_name <- str_replace_all(artist_name, bad_lyric_strings)
  song_title <- str_replace_all(song_title, bad_lyric_strings)

  # construct search path
  path <- sprintf(
    "https://genius.com/%s-%s-lyrics",
    artist_name, song_title
  )

  # check_internet()

  # start session
  session <- read_html(path)

  # get song lyrics
  get_lyricsF(session, artist_nameOld)
}

## package source code
repeat_before <- function(x, y) {
  ind <- which(y)
  if (!y[1]) {
    ind <- c(1, ind)
  }
  rep(x[ind], times = diff(
    c(ind, length(x) + 1)
  ))
}

## package source code tweaked to avoid bug
get_lyricsF <- function(session, artist) {
  # read lyrics
  lyrics <- session %>%
    html_nodes(xpath = '//div[contains(@class, "Lyrics__Container")]')

  # get meta data
  song <- session %>%
    html_nodes(xpath = '//span[contains(@class, "SongHeaderdesktop__")]') %>%
    html_text(trim = TRUE)

  # artist <-  session %>%
  #  html_nodes(xpath = '//a[contains(@class, "SongHeaderdesktop__Artist")]') %>%
  #  html_text(trim = TRUE)

  # ensure line breaks are preserved correctly
  xml2::xml_find_all(lyrics, ".//br") %>% xml2::xml_add_sibling("p", "\n")
  xml2::xml_find_all(lyrics, ".//br") %>% xml2::xml_remove()

  # get plain text lyrics
  lyrics <- html_text(lyrics, trim = TRUE)

  # split on line break
  lyrics <- unlist(strsplit(lyrics, split = "\n"))

  # keep lines w content
  lyrics <- grep(pattern = "[[:alnum:]]", lyrics, value = TRUE)

  # error handling for instrumental songs, writes NA if no lyrics
  if (is_empty(lyrics)) {
    return(tibble(
      line = NA,
      section_name = NA,
      section_artist = NA,
      song_name = song,
      artist_name = artist
    ))
  }

  # identify section tags
  section_tags <- nchar(gsub(pattern = "\\[.*\\]", "", lyrics)) == 0

  # repeat them across sections they apply to
  sections <- repeat_before(lyrics, section_tags)

  # remove square brackets
  sections <- gsub("\\[|\\]", "", sections)

  # separate section meta data
  sections <- strsplit(sections, split = ": ", fixed = TRUE)
  section_name <- sapply(sections, "[", 1)
  section_artist <- sapply(sections, "[", 2)

  section_artist[is.na(section_artist)] <- artist

  tibble(
    line = lyrics[!section_tags],
    section_name = section_name[!section_tags],
    section_artist = section_artist[!section_tags],
    song_name = song,
    artist_name = artist
  )
}