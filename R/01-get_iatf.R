################################################################################
#
#'
#' Get list of links to IATF resolutions from Department of Health website
#'
#' @param base URL to the IATF resolutions webpage. This is currently at
#'   \url{https://www.doh.gov.ph/COVID-19/IATF-Resolutions}
#'
#' @return A tibble containing absolute links to all the current IATF
#'   resolutions at time of extraction. The tibble contains the following
#'   information:
#'
#' \itemize{
#'   \item \code{id}{Resolution number}
#'   \item \code{title}{Title of resolution}
#'   \item \code{date}{Date (in <YYYY-MM-DD> format) resolution was issued}
#'   \item \code{source}{Source of resolution. This is by default from IATF}
#'   \item \code{type}{Type of document. This is by default a resolution}
#'   \item \code{url}{Absolute URL for PDF of resolution}
#'   \item \code{checked}{Date (in <YYYY-MM-DD format) table was extracted. This
#'     is by default provided by \code{Sys.Date()}}
#' }
#'
#' @examples
#' get_iatf_links(base = "http://www.doh.gov.ph/COVID-19/IATF-Resolutions")
#'
#' @export
#'
#
################################################################################

get_iatf_links <- function(base = "https://www.doh.gov.ph/COVID-19/IATF-Resolutions") {
  ## Get page table
  xx <- xml2::read_html(base) %>%
    rvest::html_nodes(css = ".panel .view-content .views-table") %>%
    rvest::html_table()

  ## Convert Resolution No. to numeric
  xx[[1]]$`Resolution No.` <- as.numeric(xx[[1]]$`Resolution No.`)

  ## Convert date to date class with format YYYY-MM-DD
  xx[[1]]$Date <- lubridate::mdy(xx[[1]]$Date)

  ## Get href links per resolution
  yy <- xml2::read_html(base) %>%
    rvest::html_nodes(css = ".panel .view-content .views-field a") %>%
    rvest::html_attr(name = "href")

  ## Extract Resolution number from links
  id <- stringr::str_remove_all(string = yy, pattern = "%20")
  id <- stringr::str_extract(string = id, pattern = "[0-9]+")

  ## Add links id to links
  yy <- data.frame(id,
                   source = "IATF",
                   type = "resolution",
                   url = yy,
                   checked = Sys.Date(),
                   stringsAsFactors = FALSE)

  ## Merge links with page table
  linkTable <- merge(xx[[1]], yy, by.x = "Resolution No.", by.y = "id")

  ## Rename fields in linkTable
  names(linkTable) <- c("id", "title", "date", "source", "type", "url", "checked")

  ## Convert to tibble
  linkTable <- tibble::tibble(linkTable)

  ## Return
  return(linkTable)
}



################################################################################
#
#'
#' Get a specific IATF resolution PDF file
#'
#' @param links A links/URLs tibble produced by either \code{get_iatf_links()}
#'   or \code{get_iatf_gazette()} functions
#' @param id A vector of number/s of IATF resolution/s to be retrieved
#'
#' @return A temporary directory path or a vector of temporary directory paths
#'   pointing to a temporary file/s for PDF of IATF resolution/s required
#'
#' @examples
#' get_iatf_pdf(links = iatfLinks, id = 29)
#'
#' @export
#'
#
################################################################################

get_iatf_pdf <- function(links, id) {
  ## Check that id is numeric
  if(class(id) == "character" | class(id) == "factor") {
    stop("Numeric value required for id. Please try again.", .call = TRUE)
  }

  ## Get href links per resolution
  href <- links$url

  ## Get available resolutions by resolution ID
  availableIDs <- links$id

  idText <- paste(availableIDs, collapse = ", ")

  ## Get availableIDs specified by id
  linksID <- availableIDs[which(availableIDs %in% id)]

  if(length(linksID) == 0) {
    stop(paste("Value/s for id is/are outside of what is currently available. Only resolutions ",
               idText, " are available. Please try again", sep = ""), call. = TRUE)
  }

  if(length(linksID) < length(id)) {
    warning(paste("Not all values for id correspond to an available resolution. Returning only ",
                   length(linksID), " of ", length(id), " resolutions requested."), call. = TRUE)
  }

  ## Concatenating vector for directory paths
  paths <- NULL

  ## Cycle through identifiers
  for(i in linksID) {

    ## Create temporary destfile
    destfile <- paste("iatfResolution", i, ".pdf", sep = "")

    ## Get URL for current resolution id
    link <- href[which(availableIDs == i)]

    ## Download resolution with current id
    curl::curl_download(url = link,
                        destfile = paste(tempdir(), destfile, sep = "/"))
  }

  ## Create vector of directory paths of temporary files
  paths <- paste(tempdir(), "/iatfResolution", linksID, ".pdf", sep = "")

  ## Return paths
  return(paths)
}


################################################################################
#
#'
#' Get list of links to IATF resolutions from Philippines Official Gazette
#'
#' @param base URL to the IATF resolutions webpage in the Official Gazette.
#'   This is currently at \url{https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/}
#' @param pages A vector of paginated webpages in which the IATF resolutions
#'   are available. This currently defaults to 1:6 as there are currently 6
#'   pages.
#'
#' @return A tibble containing absolute links to all the current IATF
#'   resolutions at time of extraction from the Official Gazette. The tibble
#'   contains the following information:
#'
#' \itemize{
#'   \item \code{id}{Resolution number}
#'   \item \code{title}{Title of resolution}
#'   \item \code{date}{Date (in <YYYY-MM-DD> format) resolution was issued}
#'   \item \code{source}{Source of resolution. This is by default from IATF}
#'   \item \code{type}{Type of document. This is by default a resolution}
#'   \item \code{url}{Absolute URL for PDF of resolution}
#'   \item \code{checked}{Date (in <YYYY-MM-DD format) table was extracted. This
#'     is by default provided by \code{Sys.Date()}}
#' }
#'
#' @examples
#' base <- "https://www.officialgazette.gov.ph/section/laws/other-issuances"
#' agency <- "inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/"
#'
#' get_iatf_gazette(base = paste(base, agency, sep = "/"), pages = 1)
#'
#' @export
#'
#
################################################################################

get_iatf_gazette <- function(base, pages = 1:5) {
  ## Create concatenating objects
  iatfID <- NULL
  iatfTitle <- NULL
  iatfDate <- NULL
  iatfURL <- NULL

  ## Cycle through resolution pages
  for(i in pages) {
    ## Create current URL page
    urlPage <- xml2::read_html(x = paste(base, "page", i,  sep = "/"))

    ## Get current page resolutions ID
    iatfID <- c(iatfID,
                urlPage %>%
                  rvest::html_nodes(css = ".large-8 .entry-title a") %>%
                  rvest::html_text() %>%
                  stringr::str_remove(pattern = "2020") %>%
                  stringr::str_extract(pattern = "[0-9]+")) %>%
                  as.numeric()

    ## Get current page resolutions Title
    iatfTitle <- c(iatfTitle,
                   urlPage %>%
                     rvest::html_nodes(css = ".large-8 p") %>%
                     rvest::html_text())

    ## Get current page resolutions Date
    iatfDate <- c(iatfDate,
                  urlPage %>%
                    rvest::html_nodes(css = ".large-8 .published") %>%
                    rvest::html_text())

    ## Get current page resolutions URL
    iatfURL <- c(iatfURL,
                 urlPage %>%
                   rvest::html_nodes(css = ".large-8 .entry-title a") %>%
                   rvest::html_attr(name = "href"))
  }

  iatfURLs <- NULL

  for(i in iatfURL) {
    resolutionPage <- xml2::read_html(x = i)

    pdfLink <- resolutionPage %>%
      rvest::html_nodes(css = "#resource a") %>%
      rvest::html_attr(name = "href")

    pdfLink <- pdfLink[1]

    iatfURLs <- c(iatfURLs, pdfLink)
  }

  ## Concatenate IATF list
  iatfLinksGazette <- data.frame(id = ifelse(stringr::str_detect(string = iatfTitle,
                                                                 pattern = "OMNIBUS"),
                                             NA, iatfID),
                                 title = iatfTitle,
                                 date = lubridate::mdy(iatfDate),
                                 source = "IATF",
                                 type = "resolution",
                                 url = iatfURLs,
                                 checked = Sys.Date(),
                                 stringsAsFactors = FALSE)

  ## Convert to tibble
  iatfLinksGazette <- tibble::tibble(iatfLinksGazette)

  ## Return IATF list
  return(iatfLinksGazette)
}
