base <- "http://www.doh.gov.ph/COVID-19/IATF-Resolutions"

x <- get_iatf_links(base = base)

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
