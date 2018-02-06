library(rAutor)
context("rAutor")

test_that("HasChange works", {
  expect_equal(HasChange(c(0,0,0,0,1), 1, .001), c(0, 0, 0, 0, 1))
})
