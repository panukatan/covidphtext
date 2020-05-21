library(stringr)

## Extract URLs of DFA press releases ##########################################

dfaLinks <- get_dfa_links(type = "press release")

usethis::use_data(dfaLinks, overwrite = TRUE, compress = "xz")

## Extract text from URLs of press releases ####################################

