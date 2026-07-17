test_that("both culture plate types return ggplots", {
  expect_s3_class(culture_plate_plot("streak"), "ggplot")
  expect_s3_class(culture_plate_plot("disc"), "ggplot")
})

test_that("disc arguments are validated", {
  expect_error(
    culture_plate_plot("disc", labels = c("A", "B"), inhibition = 0.1),
    "one non-negative radius"
  )
  expect_error(
    culture_plate_plot("disc", medium_colour = "not-a-colour"),
    "valid R colour"
  )
})
