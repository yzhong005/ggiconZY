.well_plate_vector <- function(value, argument, numeric = FALSE) {
  if (is.matrix(value)) {
    if (!identical(dim(value), c(8L, 12L))) {
      stop("`", argument, "` must be an 8 by 12 matrix or length-96 vector.",
           call. = FALSE)
    }
    value <- as.vector(t(value))
  }

  if (length(value) != 96L) {
    stop("`", argument, "` must be an 8 by 12 matrix or length-96 vector.",
         call. = FALSE)
  }
  if (numeric && !is.numeric(value)) {
    stop("`", argument, "` must contain numeric values.", call. = FALSE)
  }
  value
}

#' Draw a 96-well microplate
#'
#' @param values Optional numeric values supplied as an 8 by 12 matrix or a
#'   length-96 vector. Vectors map across rows: A1 to A12, then B1 to B12.
#' @param labels Optional labels supplied in the same layout as `values`.
#' @param palette Two colours defining the low and high ends of the value
#'   gradient.
#' @param na_colour Fill colour for wells without a value.
#' @param well_colour Outline colour for each well.
#' @param plate_colour Background colour of the plate.
#' @param label_colour Colour used for row, column, and well labels.
#' @param well_size Point size used to draw each well.
#' @param show_values Show formatted numeric values when `labels` is `NULL`.
#' @param value_digits Significant digits used when formatting values.
#'
#' @return A `ggplot` object representing an 8 by 12 microplate.
#' @export
well_plate_plot <- function(
    values = NULL,
    labels = NULL,
    palette = c("#f7fbff", "#2166ac"),
    na_colour = "white",
    well_colour = "grey35",
    plate_colour = "grey95",
    label_colour = "grey15",
    well_size = 9,
    show_values = FALSE,
    value_digits = 2) {
  if (is.null(values)) {
    values <- rep(NA_real_, 96L)
  } else {
    values <- .well_plate_vector(values, "values", numeric = TRUE)
  }

  if (!is.null(labels)) {
    labels <- as.character(.well_plate_vector(labels, "labels"))
    labels[is.na(labels)] <- ""
  }

  if (length(palette) != 2L || anyNA(palette)) {
    stop("`palette` must contain exactly two valid R colours.", call. = FALSE)
  }
  invisible(lapply(palette, .validate_colour, argument = "palette"))
  .validate_colour(na_colour, "na_colour")
  .validate_colour(well_colour, "well_colour")
  .validate_colour(plate_colour, "plate_colour")
  .validate_colour(label_colour, "label_colour")

  if (!is.numeric(well_size) || length(well_size) != 1L ||
      is.na(well_size) || !is.finite(well_size) || well_size <= 0) {
    stop("`well_size` must be one positive number.", call. = FALSE)
  }
  if (!is.numeric(value_digits) || length(value_digits) != 1L ||
      is.na(value_digits) || value_digits < 1 || value_digits > 10 ||
      value_digits != as.integer(value_digits)) {
    stop("`value_digits` must be an integer between 1 and 10.", call. = FALSE)
  }
  if (!is.logical(show_values) || length(show_values) != 1L ||
      is.na(show_values)) {
    stop("`show_values` must be TRUE or FALSE.", call. = FALSE)
  }

  row_names <- LETTERS[1:8]
  wells <- expand.grid(
    column = seq_len(12L),
    row = row_names,
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )
  wells$y <- 9L - match(wells$row, row_names)
  wells$value <- as.numeric(values)
  wells$well <- paste0(wells$row, wells$column)

  if (!is.null(labels)) {
    wells$display <- labels
  } else if (show_values) {
    wells$display <- ifelse(
      is.na(wells$value),
      "",
      trimws(formatC(
        wells$value,
        format = "fg",
        digits = as.integer(value_digits)
      ))
    )
  } else {
    wells$display <- ""
  }

  plate <- data.frame(xmin = 0.15, xmax = 12.85, ymin = 0.15, ymax = 8.85)
  row_guides <- data.frame(x = 0.45, y = 8:1, label = row_names)
  column_guides <- data.frame(x = 1:12, y = 8.55, label = 1:12)

  plot <- ggplot2::ggplot() +
    ggplot2::geom_rect(
      data = plate,
      ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = plate_colour,
      colour = "grey70",
      linewidth = 0.7
    ) +
    ggplot2::geom_point(
      data = wells,
      ggplot2::aes(x = column, y = y, fill = value),
      shape = 21,
      size = well_size,
      stroke = 0.6,
      colour = well_colour,
      show.legend = !all(is.na(wells$value))
    ) +
    ggplot2::scale_fill_gradient(
      low = palette[[1L]],
      high = palette[[2L]],
      na.value = na_colour,
      name = "Value"
    ) +
    ggplot2::geom_text(
      data = row_guides,
      ggplot2::aes(x = x, y = y, label = label),
      colour = label_colour,
      fontface = "bold",
      size = 3.5
    ) +
    ggplot2::geom_text(
      data = column_guides,
      ggplot2::aes(x = x, y = y, label = label),
      colour = label_colour,
      fontface = "bold",
      size = 3.2
    )

  if (any(nzchar(wells$display))) {
    plot <- plot + ggplot2::geom_text(
      data = wells,
      ggplot2::aes(x = column, y = y, label = display),
      colour = label_colour,
      size = 2.4
    )
  }

  plot +
    ggplot2::coord_equal(
      xlim = c(0.1, 12.9),
      ylim = c(0.1, 8.9),
      expand = FALSE,
      clip = "off"
    ) +
    ggplot2::theme_void()
}
