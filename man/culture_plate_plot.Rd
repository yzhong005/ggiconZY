\name{culture_plate_plot}
\alias{culture_plate_plot}
\title{Draw a customizable bacterial culture plate}
\usage{
culture_plate_plot(type = c("streak", "disc"),
  medium_colour = "#b24745", culture_colour = "#8f7700",
  labels = c("TZP", "AMC", "MEM", "CTX", "TGC", "NEW"),
  inhibition = c(0.2, 0.1, 0.25, 0, 0.15, 0.18), isolate_id = NULL)
}
\arguments{
\item{type}{Either \code{"streak"} or \code{"disc"}.}
\item{medium_colour}{Colour of the agar medium.}
\item{culture_colour}{Colour of the streak and colonies.}
\item{labels}{Labels printed on diffusion discs.}
\item{inhibition}{One non-negative inhibition-zone radius per disc.}
\item{isolate_id}{Optional centre label for a diffusion plate.}
}
\value{A ggplot object.}
\description{
Draws a streak plate with colonies or a disc-diffusion plate with evenly spaced
discs and configurable inhibition zones.
}
\examples{
culture_plate_plot("streak")
culture_plate_plot("disc", isolate_id = "Isolate 01")
}
