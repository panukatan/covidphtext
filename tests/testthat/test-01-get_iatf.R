library(httr)
set_config(config(ssl_verifypeer = 0L))

## Test get_iatf_links #########################################################
x <- get_iatf_links()

test_that("x is a tibble", {
  expect_is(x, "tbl")
})

test_that("x has 7 columns", {
  expect_equal(ncol(x), 7)
})

test_that("id is numeric", {
  expect_is(x$id, "numeric")
})

test_that("date is a date", {
  expect_is(x$date, "Date")
})

test_that("source is iatf", {
  expect_true(all(x$source == "IATF"))
})

test_that("url is a url", {
  expect_true(all(stringr::str_detect(x$url, "http")))
})


## Test get_iatf_pdf ###########################################################

links <- iatfLinksGazette

x <- get_iatf_pdfs(links = links, id = 10)

test_that("path is character", {
  expect_is(x, "character")
})

test_that("name of filename vector is correct", {
  expect_true(names(x) == "iatfResolution10")
})

test_that("error message shows", {
  expect_error(get_iatf_pdfs(links = iatfLinks, id = "1"))
  expect_error(get_iatf_pdfs(links = iatfLinks, id = 1))
  expect_warning(get_iatf_pdfs(links = iatfLinks, id = c(1, 10)))
})


test_that("message shows", {
  expect_message(get_iatf_pdf(link = "https://doh.gov"))
})


## Test get_iatf_gazette #######################################################
pages <- list_iatf_pages(pages = 1)
iatfPages <- get_iatf_pages(pages = pages)
x <- get_iatf_gazette(iatfPages)

test_that("x is a tibble", {
  expect_is(x, "tbl")
})

test_that("x has 7 columns", {
  expect_equal(ncol(x), 7)
})

test_that("id is numeric", {
  expect_is(x$id, "numeric")
})

test_that("date is a date", {
  expect_is(x$date, "Date")
})

test_that("source is iatf", {
  expect_true(all(x$source == "IATF"))
})

test_that("url is a url", {
  expect_true(all(stringr::str_detect(x$url, "http")))
})


test_that("errors and returns NA", {
  expect_true(is.na(get_iatf_page(page = list_iatf_pages(pages = 9))))
})
