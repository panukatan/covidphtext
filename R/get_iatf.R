################################################################################
#
#'
#' Get list of links to IATF resolutions from Department of Health website
#'
#' @param base URL to the Department of Health IATF resolutions webpage. This
#'   is currently at \url{http://www.doh.gov.ph/COVID-19/IATF-Resolutions/}
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
#'     is by default provided by \link{Sys.Date}}
#' }
#'
#' @examples
#' base <- system.file("extdata", "iatf.html", package = "covidphtext")
#' get_iatf_links(base = base)
#'
#' @export
#'
#
################################################################################

get_iatf_links <- function(base = base_urls[[1]]) {
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
#' Get a specific IATF resolution PDF file given a link
#'
#' @param link A URL to an IATF resolution PDF
#'
#' @return A temporary directory path for PDF of IATF resolution specified
#'
#' @examples
#' get_iatf_pdf(link = iatfLinksGazette$url[1])
#'
#' @export
#'
#
################################################################################

get_iatf_pdf <- function(link) {
  destfile <- tempfile()

  handle <- curl::new_handle()

  handle <- curl::handle_setopt(handle,
                                useragent = "https://como-ph.github.io/covidphtext")

  ## Download resolution with current id
  x <- try(curl::curl_download(url = link,
                               destfile = destfile,
                               handle = handle))

  if(class(x) == "try-error") {
    message("Unable to download PDF. Returning NA.")
    destfile <- NA
  }

  ## Return path
  return(destfile)
}


################################################################################
#
#'
#' Get a specific IATF resolution PDF file
#'
#' @param links A links/URLs tibble produced by either \link{get_iatf_links}
#'   or \link{get_iatf_gazette} functions
#' @param id A vector of number/s of IATF resolution/s to be retrieved
#'
#' @return A temporary directory path or a vector of temporary directory paths
#'   pointing to a temporary file/s for PDF of IATF resolution/s required
#'
#' @examples
#' get_iatf_pdfs(links = iatfLinksGazette, id = 1)
#'
#' @export
#'
#
################################################################################

get_iatf_pdfs <- function(links, id) {
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

  ## Get URLs for specified resolution ids
  link <- href[which(availableIDs %in% linksID)]

  paths <- lapply(X = link,
                  FUN = get_iatf_pdf)

  ## Unlist
  paths <- unlist(paths)

  names(paths) <- ifelse(linksID < 10,
                         paste("iatfResolution0", linksID, sep = ""),
                         paste("iatfResolution", linksID, sep = ""))

  ## Return paths
  return(paths)
}


################################################################################
#
#'
#' List the URL of all pages of the IATF Resolutions in the Official Gazette
#'
#' @param base URL to the IATF resolutions webpage in the Official Gazette.
#'   This is currently at \url{https://www.officialgazette.gov.ph/section/laws/other-issuances/inter-agency-task-force-for-the-management-of-emerging-infectious-diseases-resolutions/}
#' @param pages A vector of paginated webpages in which the IATF resolutions
#'   are available. There are currently 8 pages.
#'
#' @return A character vector of URLs of all pages of the IATF Resolutions in
#'   the Official Gazette
#'
#' @examples
#' list_iatf_pages(pages = 1)
#'
#' @export
#'
#
################################################################################

list_iatf_pages <- function(base = base_urls[[2]],
                            pages) {
  paste(base, "page/", pages, "/", sep = "")
}


################################################################################
#
#'
#' Get contents of an IATF page from the Official Gazette
#'
#' @param page A URL of a page of the IATF Resolutions in the Official Gazette
#'   website.
#'
#' @return A tibble containing absolute links to all the current IATF
#'   resolutions from specified page at time of extraction from the Official
#'   Gazette. The tibble contains the following information:
#'
#' \itemize{
#'   \item \code{id}{Resolution number}
#'   \item \code{title}{Title of resolution}
#'   \item \code{date}{Date (in <YYYY-MM-DD> format) resolution was issued}
#'   \item \code{source}{Source of resolution. This is by default from IATF}
#'   \item \code{type}{Type of document. This is by default a resolution}
#'   \item \code{url}{Absolute URL for the webpage of the resolution}
#'   \item \code{checked}{Date (in <YYYY-MM-DD format) table was extracted. This
#'     is by default provided by \link{Sys.Date}}
#' }
#'
#' @examples
#' pages <- list_iatf_pages(pages = 1)
#' get_iatf_page(page = pages)
#'
#' @export
#'
#
################################################################################

get_iatf_page <- function(page) {
  ##
  urlPage <- try(xml2::read_html(x = page))

  ##
  if(any(class(urlPage) == "try-error")) {
    iatfPage <- NA
  } else {
    ## Get current page resolutions Title
    iatfTitle <- urlPage %>%
      rvest::html_nodes(css = ".large-8 p") %>%
      rvest::html_text()

    ## Get current page resolutions id
    iatfID <- urlPage %>%
      rvest::html_nodes(css = ".large-8 .entry-title a") %>%
      rvest::html_text() %>%
      stringr::str_remove(pattern = "2020|2021|2022") %>%
      stringr::str_extract(pattern = "[0-9]+") %>%
      as.numeric()

    iatfID <- ifelse(stringr::str_detect(string = iatfTitle,
                                         pattern = "OMNIBUS"),
                     NA, iatfID)

    ## Get current page resolutions Date
    iatfDate <- urlPage %>%
      rvest::html_nodes(css = ".large-8 .published") %>%
      rvest::html_text()

    iatfDate <- lubridate::mdy(iatfDate)

    ## Get current page resolutions URL
    iatfURL <- urlPage %>%
      rvest::html_nodes(css = ".large-8 .entry-title a") %>%
      rvest::html_attr(name = "href")

    ## Concatenate
    iatfPage <- tibble::tibble(iatfID,
                               iatfTitle,
                               iatfDate,
                               source = "IATF",
                               type = "resolution",
                               iatfURL,
                               checked = Sys.Date())
  }

  ## Return iatfPage
  return(iatfPage)
}



################################################################################
#
#'
#' Get contents of the IATF pages from the Official Gazette
#'
#' @param pages A character vector of URLs of all pages of the IATF Resolutions
#'   in the Official Gazette. This can be created using \link{list_iatf_pages}
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
#'   \item \code{url}{Absolute URL for the webpage of the resolution}
#'   \item \code{checked}{Date (in <YYYY-MM-DD format) table was extracted. This
#'     is by default provided by \link{Sys.Date}}
#' }
#'
#' @examples
#' pages <- list_iatf_pages(pages = 1)
#' get_iatf_pages(pages = pages)
#'
#' @export
#'
#
################################################################################

get_iatf_pages <- function(pages) {
  ##
  iatfPages <- lapply(X = pages,
                      FUN = get_iatf_page)

  ## Unlist
  iatfPages <- dplyr::bind_rows(iatfPages, .id = NULL)

  ## Rename iatfPages
  names(iatfPages) <- c("id", "title", "date", "source",
                        "type", "url", "checked")

  ## Return elements of IATF pages
  return(iatfPages)
}


################################################################################
#
#'
#' Get list of links to IATF resolutions from Philippines Official Gazette
#'
#' @param iatfPages A tibble created by a call to \link{get_iatf_pages}.
#'
#' @return A tibble containing absolute links to the PDF of the current IATF
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
#'     is by default provided by \link{Sys.Date}}
#' }
#'
#' @examples
#' get_iatf_gazette(iatfPages[1, ])
#'
#'
#' @export
#'
#
################################################################################

get_iatf_gazette <- function(iatfPages) {
  ## Get URLs
  iatfURL <- iatfPages$url

  ##
  pdfLink <- lapply(X = iatfURL,
                    FUN = function(x) {
                      resolutionPage <- try(xml2::read_html(x = x))

                      if(any(class(resolutionPage) == "try-error")) {
                        pdfLink <- NA
                      } else {

                        pdfLink <- resolutionPage %>%
                          rvest::html_nodes(css = "#resource a") %>%
                          rvest::html_attr(name = "href")
                      }

                      pdfLink <- pdfLink[1]
                    })

  ##
  iatfPages$url <- pdfLink[[1]]

  ## Return iatfPages
  return(iatfPages)
}
