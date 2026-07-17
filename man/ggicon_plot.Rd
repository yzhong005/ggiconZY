\name{ggicon_plot}
\alias{ggicon_plot}
\title{Draw a scientific icon}
\usage{
ggicon_plot(icon, colour = "black", size = 0.1, alpha = 1,
  max_points = Inf)
}
\arguments{
\item{icon}{One icon name returned by \code{ggicon_names()}.}
\item{colour}{Icon colour. For \code{panda}, the darkest gradient colour.}
\item{size}{Point size passed to \code{ggplot2::geom_point()}.}
\item{alpha}{Point opacity between zero and one.}
\item{max_points}{Maximum coordinates to draw.}
}
\value{A ggplot object with equal coordinates and no axes.}
\description{Draws one bundled coordinate icon as a standalone ggplot.}
\examples{
ggicon_plot("mouse", max_points = 1000)
}
