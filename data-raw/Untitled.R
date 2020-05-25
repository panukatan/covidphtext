iatfURLs <- NULL

for(i in xx) {
  resolutionPage <- xml2::read_html(x = i)

  pdfLink <- resolutionPage %>%
    rvest::html_nodes(css = "#resource a") %>%
    rvest::html_attr(name = "href")

  pdfLink <- pdfLink[1]

  iatfURLs <- c(iatfURLs, pdfLink)
}
