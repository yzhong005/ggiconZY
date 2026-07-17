\name{well_plate_plot}
\alias{well_plate_plot}
\title{Draw a 96-well microplate}
\usage{
well_plate_plot(values = NULL, labels = NULL,
  palette = c("#f7fbff", "#2166ac"), na_colour = "white",
  well_colour = "grey35", plate_colour = "grey95",
  label_colour = "grey15", well_size = 9, show_values = FALSE,
  value_digits = 2)
}
\arguments{
\item{values}{Optional numeric values supplied as an 8 by 12 matrix or a
length-96 vector. Vectors map from A1 to A12, then B1 to B12.}
\item{labels}{Optional labels supplied in the same layout as \code{values}.}
\item{palette}{Two colours defining the low and high value gradient.}
\item{na_colour}{Fill colour for wells without a value.}
\item{well_colour}{Outline colour for each well.}
\item{plate_colour}{Background colour of the plate.}
\item{label_colour}{Colour for row, column, and well labels.}
\item{well_size}{Point size used to draw each well.}
\item{show_values}{Show formatted values when \code{labels} is \code{NULL}.}
\item{value_digits}{Significant digits used when formatting values.}
}
\value{A ggplot object representing an 8 by 12 microplate.}
\description{
Draws a standard 96-well plate with optional numeric heatmap values and custom
labels. Row and column guides use conventional well IDs A1 through H12.
}
\examples{
well_plate_plot()
well_plate_plot(seq_len(96), show_values = TRUE)
}
