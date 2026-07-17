\name{annotation_ggicon}
\alias{annotation_ggicon}
\title{Place a scientific icon in another ggplot}
\usage{
annotation_ggicon(icon, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf,
  colour = "black", size = 0.1, alpha = 1, max_points = Inf)
}
\arguments{
\item{icon}{One icon name returned by \code{ggicon_names()}.}
\item{xmin, xmax, ymin, ymax}{Icon bounds in the parent plot's data coordinates.}
\item{colour}{Icon colour.}
\item{size}{Icon point size.}
\item{alpha}{Icon point opacity.}
\item{max_points}{Maximum coordinates to draw.}
}
\value{A layer created by \code{ggplot2::annotation_custom()}.}
\description{Creates an icon grob and positions it inside another ggplot.}
\examples{
if (requireNamespace("ggplot2", quietly = TRUE)) {
  ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    annotation_ggicon("mouse", 2, 3, 25, 35, max_points = 1000)
}
}
