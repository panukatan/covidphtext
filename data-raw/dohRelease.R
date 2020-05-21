library(rvest)
library(stringr)
library(comotext)

## Extract press releases URLs #################################################

dohLinks <- get_doh_links(pages = 1:25)

usethis::use_data(dohLinks, overwrite = TRUE, compress = "xz")

## Extract text from press releases ############################################

dohRelease <- NULL

for(i in 1:nrow(dohReleaseLinks)) {
  currentPR <- get_doh_release(df = dohReleaseLinks[i, ])

  dohRelease <- rbind(dohRelease, currentPR)
}

usethis::use_data(dohRelease, overwrite = TRUE, compress = "xz")

