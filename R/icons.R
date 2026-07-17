.ggicon_files <- c(
  drosophila = "extdata/icons/drosophila.csv",
  male = "extdata/icons/male.csv",
  mouse = "extdata/icons/mouse.csv",
  panda = "extdata/icons/panda.csv",
  singapore = "extdata/icons/singapore.csv"
)

.ggicon_cache <- new.env(parent = emptyenv())

.ggicon_asset <- function(path) {
  asset <- system.file(path, package = "ggiconZY")
  if (!nzchar(asset)) {
    stop("The bundled ggiconZY asset could not be found: ", path, call. = FALSE)
  }
  asset
}

.read_ggicon_csv <- function(path, refresh = FALSE) {
  if (!isTRUE(refresh) && exists(path, envir = .ggicon_cache, inherits = FALSE)) {
    return(get(path, envir = .ggicon_cache, inherits = FALSE))
  }

  value <- utils::read.csv(
    .ggicon_asset(path),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )

  unnamed <- names(value) == "" | grepl("^X(\\.[0-9]+)?$", names(value))
  if (any(unnamed)) {
    value <- value[, !unnamed, drop = FALSE]
  }

  assign(path, value, envir = .ggicon_cache)
  value
}

#' List the bundled scientific icons
#'
#' @return A character vector of icon names accepted by [ggicon_data()] and
#'   [ggicon_plot()].
#' @export
ggicon_names <- function() {
  names(.ggicon_files)
}

#' Load a bundled icon dataset
#'
#' @param icon One icon name returned by [ggicon_names()].
#' @param max_points Maximum number of coordinate rows to return. The default,
#'   `Inf`, preserves the original data. A smaller value provides a fast,
#'   deterministic preview for dense icons.
#' @param refresh Reload the CSV instead of using the in-session cache.
#'
#' @return A data frame containing at least numeric `x` and `y` columns.
#' @export
ggicon_data <- function(icon, max_points = Inf, refresh = FALSE) {
  icon <- match.arg(icon, ggicon_names())

  if (!is.numeric(max_points) || length(max_points) != 1L ||
      is.na(max_points) || max_points <= 0) {
    stop("`max_points` must be one positive number or Inf.", call. = FALSE)
  }

  value <- .read_ggicon_csv(.ggicon_files[[icon]], refresh = refresh)

  if (!all(c("x", "y") %in% names(value))) {
    stop("The icon dataset is missing its x/y coordinates.", call. = FALSE)
  }

  value$x <- as.numeric(value$x)
  value$y <- as.numeric(value$y)
  if ("value" %in% names(value)) {
    value$value <- as.numeric(value$value)
  }
  if (anyNA(value$x) || anyNA(value$y)) {
    stop("The icon dataset contains invalid x/y coordinates.", call. = FALSE)
  }

  if (is.finite(max_points) && nrow(value) > max_points) {
    count <- max(1L, as.integer(floor(max_points)))
    index <- unique(as.integer(round(seq.int(1, nrow(value), length.out = count))))
    value <- value[index, , drop = FALSE]
  }

  rownames(value) <- NULL
  value
}

#' Draw a scientific icon
#'
#' @param icon One icon name returned by [ggicon_names()].
#' @param colour Icon colour. For `panda`, this is the darkest gradient colour.
#' @param size Point size passed to [ggplot2::geom_point()].
#' @param alpha Point opacity between zero and one.
#' @param max_points Maximum number of coordinates to draw. Use a smaller value
#'   for a faster preview of dense icons.
#'
#' @return A `ggplot` object with an equal aspect ratio and no axes.
#' @export
ggicon_plot <- function(icon, colour = "black", size = 0.1, alpha = 1,
                        max_points = Inf) {
  icon <- match.arg(icon, ggicon_names())
  value <- ggicon_data(icon, max_points = max_points)
  plot <- ggplot2::ggplot(value, ggplot2::aes(x = x, y = y))

  if (identical(icon, "panda") && "value" %in% names(value)) {
    plot <- plot +
      ggplot2::geom_point(ggplot2::aes(colour = value), size = size, alpha = alpha) +
      ggplot2::scale_colour_gradient(low = "white", high = colour, guide = "none")
  } else {
    plot <- plot + ggplot2::geom_point(colour = colour, size = size, alpha = alpha)
  }

  plot + ggplot2::coord_equal() + ggplot2::theme_void()
}

#' Place a scientific icon in another ggplot
#'
#' @param icon One icon name returned by [ggicon_names()].
#' @param xmin,xmax,ymin,ymax Position of the icon in the parent plot's data
#'   coordinates.
#' @inheritParams ggicon_plot
#'
#' @return A ggplot layer created by [ggplot2::annotation_custom()].
#' @export
annotation_ggicon <- function(icon, xmin = -Inf, xmax = Inf,
                              ymin = -Inf, ymax = Inf, colour = "black",
                              size = 0.1, alpha = 1, max_points = Inf) {
  grob <- ggplot2::ggplotGrob(
    ggicon_plot(
      icon,
      colour = colour,
      size = size,
      alpha = alpha,
      max_points = max_points
    )
  )

  ggplot2::annotation_custom(
    grob = grob,
    xmin = xmin,
    xmax = xmax,
    ymin = ymin,
    ymax = ymax
  )
}
