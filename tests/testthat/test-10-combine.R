x <- combine_docs(docs = "resolution")


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

test_that("linenumbers is re-assigned and is unique", {
  expect_true(!anyDuplicated(x$linenumber))
})

x <- combine_iatf()

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

