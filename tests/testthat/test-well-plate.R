test_that("blank and numeric well plates return ggplots", {
  expect_s3_class(well_plate_plot(), "ggplot")
  expect_s3_class(well_plate_plot(seq_len(96)), "ggplot")
  expect_s3_class(well_plate_plot(matrix(seq_len(96), 8, 12)), "ggplot")
})

test_that("well plate inputs use conventional row-major mapping", {
  plot <- well_plate_plot(seq_len(96))
  well_data <- plot$layers[[2]]$data

  expect_identical(well_data$well[c(1, 12, 13, 96)], c("A1", "A12", "B1", "H12"))
  expect_identical(well_data$value[c(1, 12, 13, 96)], c(1, 12, 13, 96))

  matrix_values <- matrix(seq_len(96), nrow = 8, byrow = TRUE)
  matrix_data <- well_plate_plot(matrix_values)$layers[[2]]$data
  expect_identical(matrix_data$value, as.numeric(seq_len(96)))
})

test_that("labels and displayed values are supported", {
  labels <- rep("", 96)
  labels[c(1, 96)] <- c("Blank", "QC")

  labelled <- well_plate_plot(seq_len(96), labels = labels)
  expect_true(any(labelled$layers[[5]]$data$display == "Blank"))

  displayed <- well_plate_plot(seq_len(96), show_values = TRUE)
  expect_true(any(displayed$layers[[5]]$data$display == "96"))
})

test_that("invalid well plate inputs fail clearly", {
  expect_error(well_plate_plot(1:12), "length-96")
  expect_error(well_plate_plot(matrix(1:96, 12, 8)), "8 by 12")
  expect_error(well_plate_plot(rep("x", 96)), "numeric")
  expect_error(well_plate_plot(palette = "red"), "exactly two")
  expect_error(well_plate_plot(value_digits = 0), "between 1 and 10")
})
