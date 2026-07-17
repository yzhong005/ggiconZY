test_that("the icon catalog is stable", {
  expect_identical(
    ggicon_names(),
    c("drosophila", "male", "mouse", "panda", "singapore")
  )
})

test_that("every icon has numeric coordinates", {
  for (icon in ggicon_names()) {
    value <- ggicon_data(icon)
    expect_s3_class(value, "data.frame")
    expect_true(all(c("x", "y") %in% names(value)))
    expect_type(value$x, "double")
    expect_type(value$y, "double")
    expect_false(anyNA(value$x))
    expect_false(anyNA(value$y))
    expect_gt(nrow(value), 0)
  }
})

test_that("dense icon previews are deterministic and bounded", {
  first <- ggicon_data("panda", max_points = 1000)
  second <- ggicon_data("panda", max_points = 1000)

  expect_lte(nrow(first), 1000)
  expect_identical(first, second)
})

test_that("icons create ggplot objects and annotation layers", {
  expect_s3_class(ggicon_plot("mouse", max_points = 100), "ggplot")
  expect_true(inherits(
    annotation_ggicon("mouse", max_points = 100),
    "LayerInstance"
  ))
})

test_that("invalid icon arguments fail clearly", {
  expect_error(ggicon_data("unknown"))
  expect_error(ggicon_data("mouse", max_points = 0), "positive")
})
