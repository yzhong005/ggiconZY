plate_columns_example <- function() {
  value <- data.frame(column = 1:12)
  for (index in seq_along(LETTERS[1:8])) {
    value[[LETTERS[[index]]]] <- seq_len(12) + (index - 1L) * 12L
  }
  value
}

test_that("the previous plate_columns workflow maps wells correctly", {
  imported <- read_plate_reader(plate_columns_example())

  expect_identical(dim(imported), c(8L, 12L))
  expect_identical(rownames(imported), LETTERS[1:8])
  expect_identical(colnames(imported), as.character(1:12))
  expect_equal(unname(imported[c("A", "B", "H"), c("1", "12")]),
               matrix(c(1, 13, 85, 12, 24, 96), nrow = 3))
  expect_identical(attr(imported, "plate_reader_layout"), "plate_columns")
})

test_that("plate_rows exports are reordered to A1 through H12", {
  measurements <- matrix(seq_len(96), nrow = 8, byrow = TRUE)
  export <- data.frame(row = rev(LETTERS[1:8]), measurements[8:1, ],
                       check.names = FALSE)
  names(export)[-1] <- as.character(1:12)

  imported <- read_plate_reader(export)
  expect_identical(as.numeric(t(imported)), as.numeric(seq_len(96)))
  expect_identical(attr(imported, "plate_reader_layout"), "plate_rows")
})

test_that("long exports accept named measurement columns and missing wells", {
  wells <- as.vector(t(outer(LETTERS[1:8], 1:12, paste0)))
  export <- data.frame(
    Well = wells[-96],
    Time = seq_len(95),
    OD600 = seq_len(95) / 100
  )

  imported <- read_plate_reader(export, value_column = "OD600")
  expect_equal(imported["A", "1"], 0.01)
  expect_equal(imported["H", "11"], 0.95)
  expect_true(is.na(imported["H", "12"]))
  expect_identical(attr(imported, "plate_reader_layout"), "long")
})

test_that("CSV exports are read from disk", {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path), add = TRUE)
  utils::write.csv(plate_columns_example(), path, row.names = FALSE)

  imported <- read_plate_reader(path)
  expect_equal(imported["A", "1"], 1)
  expect_equal(imported["H", "12"], 96)
})

test_that("plate-reader failures explain how to resolve the layout", {
  expect_error(read_plate_reader(data.frame(foo = 1:3)), "Could not recognize")
  expect_error(read_plate_reader("missing.csv"), "does not exist")

  duplicate <- data.frame(Well = c("A1", "A1"), Value = c(1, 2))
  expect_error(read_plate_reader(duplicate), "duplicate well IDs")

  multiple <- data.frame(Well = c("A1", "A2"), first = 1:2, second = 3:4)
  expect_error(read_plate_reader(multiple), "value_column")
})
