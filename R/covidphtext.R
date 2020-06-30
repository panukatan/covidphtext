################################################################################
#
#'
#' Utilities to Extract Text Data From COVID-19-Related Resolutions and Policies
#' from the Philippines
#'
#' To assess possible impact of various COVID-19 prediction models on
#' Philippine government response, text from various resolutions, press
#' releases and legislation has been collected using data mining approaches
#' implemented in R. This package includes functions used for this data
#' mining process and datasets of text that have been collected and processed
#' for use in text analysis.
#'
#' @docType package
#' @name covidphtext
#' @keywords internal
#' @importFrom utils data download.file
#' @importFrom stringr str_to_title str_detect str_wrap str_trim str_subset
#'   str_split str_split_fixed str_remove_all str_extract str_to_upper
#'   str_replace
#' @importFrom tibble tibble
#' @importFrom xml2 read_html url_absolute
#' @importFrom rvest html_nodes html_text html_attr html_table
#' @importFrom magrittr %>%
#' @importFrom lubridate mdy dmy
#' @importFrom curl curl_download
#'
#
################################################################################
"_PACKAGE"

## quiets concerns of R CMD check re: iatfLinksGazette
if(getRversion() >= "2.15.1")  utils::globalVariables("iatfLinksGazette")
