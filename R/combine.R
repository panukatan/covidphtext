################################################################################
#
#' Combine specific documents available in the covidphtext package into a single
#' dataset
#'
#' @param docs A vector of terms to search for in the document names
#'
#' @return A tibble of all document types called for.
#'
#' @examples
#' combine_docs(docs = "resolution")
#'
#' @export
#'
#
################################################################################

combine_docs <- function(docs = c("resolution", "press release")) {
  ## Get multiple variations of search term
  x <- NULL

  for(i in docs) {
    x <- c(x,
           stringr::str_to_title(string = i),
           stringr::str_split_fixed(string = i, pattern = " ", n = 2),
           paste(i, collapse = ""))
  }

  x <- x[x != ""]

  ## Check whether dataset names in comotext matches search term
  y <- stringr::str_detect(string = utils::data(package = "covidphtext")$results[ , "Item"],
                           pattern = paste(x, collapse = "|"))

  ## Retrieve dataset names matching search terms
  z <- utils::data(package = "covidphtext")$results[ , "Item"][y]

  ## Create concatenating data.frame
  allDocs <- data.frame()

  ## Cycle through dataset names matching search term
  for(i in z) {
    allDocs <- rbind(allDocs, eval(parse(text = i)))
  }

  #allDocs$linenumber <- seq_len(nrow(allDocs))

  allDocs <- tibble::tibble(allDocs)

  ## Return allDocs
  return(allDocs)
}


################################################################################
#
#' Combine all Inter-Agency Task Force for the management of emerging
#' infectious diseases (IATF) resolutions datasets into a single dataset
#'
#' @param docs A vector of terms to search for in the document names
#' @param res A vector of document identifiers to concatenate. Default is
#'   sequence of resolution IDs found in \code{iatfLinksGazette}
#'
#' @return A tibble of all the IATF resolutions
#'
#' @examples
#' combine_iatf()
#'
#' @export
#'
#
################################################################################

combine_iatf <- function(docs = "iatfResolution",
                         res = seq_len(max(iatfLinksGazette$id, na.rm = TRUE))) {
  ##
  x <- ifelse(res < 10, paste("0", res, sep = ""), res)

  ## Extract required docs
  allRes <- combine_docs(docs = paste(docs, x, sep = ""))

  ## Return allRes
  return(allRes)
}
