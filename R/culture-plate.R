.culture_data <- function(name) {
  .read_ggicon_csv(paste0("extdata/icons/culture/", name, ".csv"))
}

.validate_colour <- function(value, argument) {
  if (length(value) != 1L || is.na(value)) {
    stop("`", argument, "` must be one valid R colour.", call. = FALSE)
  }
  tryCatch(
    grDevices::col2rgb(value),
    error = function(error) {
      stop("`", argument, "` must be one valid R colour.", call. = FALSE)
    }
  )
  invisible(value)
}

#' Draw a customizable bacterial culture plate
#'
#' @param type Either `"streak"` for a streak plate with colonies or `"disc"`
#'   for an antimicrobial disc-diffusion plate.
#' @param medium_colour Colour of the agar medium.
#' @param culture_colour Colour of the streak and colonies.
#' @param labels Labels printed on diffusion discs.
#' @param inhibition Relative inhibition-zone radii, one per disc.
#' @param isolate_id Optional label printed at the centre of a diffusion plate.
#'
#' @return A `ggplot` object.
#' @export
culture_plate_plot <- function(
    type = c("streak", "disc"),
    medium_colour = "#b24745",
    culture_colour = "#8f7700",
    labels = c("TZP", "AMC", "MEM", "CTX", "TGC", "NEW"),
    inhibition = c(0.20, 0.10, 0.25, 0, 0.15, 0.18),
    isolate_id = NULL) {
  type <- match.arg(type)
  .validate_colour(medium_colour, "medium_colour")
  .validate_colour(culture_colour, "culture_colour")

  agar <- .culture_data("agar")
  inner_agar <- transform(agar, x = 0.98 * x, y = 0.98 * y)

  plot <- ggplot2::ggplot() +
    ggplot2::geom_polygon(
      data = agar,
      ggplot2::aes(x = x, y = y),
      colour = "black",
      fill = "grey50",
      alpha = 0.2,
      linewidth = 1
    ) +
    ggplot2::geom_polygon(
      data = inner_agar,
      ggplot2::aes(x = x, y = y),
      colour = "black",
      fill = medium_colour,
      alpha = 0.5,
      linewidth = 1
    )

  if (identical(type, "streak")) {
    streak <- .culture_data("streak")
    colonies <- .culture_data("colonies")

    return(
      plot +
        ggplot2::geom_segment(
          data = streak,
          ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
          lineend = "round",
          linejoin = "round",
          linewidth = 8,
          colour = culture_colour,
          alpha = 0.25
        ) +
        ggplot2::geom_segment(
          data = streak,
          ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
          lineend = "round",
          linejoin = "round",
          linewidth = 3,
          colour = culture_colour,
          alpha = 0.65
        ) +
        ggplot2::geom_point(
          data = colonies,
          ggplot2::aes(x = x, y = y),
          colour = culture_colour,
          size = 4,
          alpha = 0.75
        ) +
        ggplot2::coord_equal(
          xlim = c(-1.05, 1.05),
          ylim = c(-1.05, 1.05),
          expand = FALSE
        ) +
        ggplot2::theme_void()
    )
  }

  if (!length(labels) || anyNA(labels)) {
    stop("`labels` must contain at least one non-missing label.", call. = FALSE)
  }
  if (length(inhibition) != length(labels) || anyNA(inhibition) ||
      any(!is.finite(inhibition)) || any(inhibition < 0)) {
    stop("`inhibition` must contain one non-negative radius per label.", call. = FALSE)
  }

  angles <- seq(0, 2 * pi, length.out = length(labels) + 1L)[-1L]
  discs <- data.frame(
    x = 0.70 * sin(angles),
    y = 0.70 * cos(angles),
    label = as.character(labels),
    stringsAsFactors = FALSE
  )

  zone_parts <- lapply(seq_along(labels), function(index) {
    if (inhibition[[index]] == 0) {
      return(NULL)
    }
    data.frame(
      x = inhibition[[index]] * agar$x + discs$x[[index]],
      y = inhibition[[index]] * agar$y + discs$y[[index]],
      zone = index
    )
  })
  zone_parts <- Filter(Negate(is.null), zone_parts)

  if (length(zone_parts)) {
    zones <- do.call(rbind, zone_parts)
    plot <- plot + ggplot2::geom_polygon(
      data = zones,
      ggplot2::aes(x = x, y = y, group = zone),
      fill = medium_colour,
      colour = "grey85",
      alpha = 0.75
    )
  }

  plot <- plot +
    ggplot2::geom_point(
      data = discs,
      ggplot2::aes(x = x, y = y),
      size = 8,
      colour = "white"
    ) +
    ggplot2::geom_text(
      data = discs,
      ggplot2::aes(x = x, y = y, label = label),
      size = 2,
      fontface = "bold"
    )

  if (!is.null(isolate_id)) {
    if (length(isolate_id) != 1L || is.na(isolate_id)) {
      stop("`isolate_id` must be NULL or one non-missing value.", call. = FALSE)
    }
    plot <- plot + ggplot2::geom_text(
      ggplot2::aes(x = 0, y = 0, label = as.character(isolate_id)),
      size = 5,
      fontface = "bold"
    )
  }

  plot +
    ggplot2::coord_equal(
      xlim = c(-1.05, 1.05),
      ylim = c(-1.05, 1.05),
      expand = FALSE
    ) +
    ggplot2::theme_void()
}
