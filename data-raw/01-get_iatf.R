################################################################################
#
#'
#' Get list of links to IATF resolutions
#'
#' @param base URL to the IATF resolutions webpage
#'
#' @return A tibble of links to all the current IATF resolutions
#'
#' @examples
#' get_iatf_links()
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
  yy <- data.frame(id, link = yy, stringsAsFactors = FALSE)

  ## Merge links with page table
  linkTable <- merge(xx[[1]], yy, by.x = "Resolution No.", by.y = "id")
  names(linkTable) <- c("id", "title", "date", "link")

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
#' @param id A vector of resolution number/s of IATF resolution to be retrieved.
#'   Numeric ranging from current resolution numbers available via
#'   \code{iatfResList}. Default is all values for resolution identifiers
#'   available via \code{iatfResList}
#' @param ssl Logical. Should SSL/https version of site be used? Default is
#'   TRUE
#'
#' @return A temporary directory path pointing to a temporary file for PDF
#'   of IATF resolution required
#'
#' @examples
#' #get_iatf_pdf(id = 9, ssl = FALSE)
#'
#'
#
################################################################################

get_iatf_pdf <- function(id = iatfResList$id,
                         ssl = TRUE) {
  ## Check that id is within range of iatfRestList
  if(all(!id %in% iatfResList$id)) {
    stop("Value/s for id is/are outside of what is currently available. Please try again", .call = TRUE)
  }

  ## Check that id is numeric
  if(class(id) != "numeric") {
    stop("Numeric value required for id. Please try again.", .call = TRUE)
  }

  ## Concatenating vector for directory paths
  paths <- NULL

  ## Cycle through identifiers
  for(i in id) {

    ## Create temporary destfile
    destfile <- paste("iatfResolution", i, ".pdf", sep = "")

    ## Get URL for current resolution id
    link <- iatfResList$link[iatfResList$id == i]

    if(!ssl) {
      link <- stringr::str_replace(string = link, pattern = "https", replacement = "http")
    }

    ## Download resolution with current id
    utils::download.file(url = link,
                         destfile = paste(tempdir(), destfile, sep = "/"))
  }

  ## Create vector of directory paths of temporary files
  paths <- paste(tempdir(), "/iatfResolution", id, ".pdf", sep = "")

  ## Return paths
  return(paths)
}
