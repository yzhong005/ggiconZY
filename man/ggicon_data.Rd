\name{ggicon_data}
\alias{ggicon_data}
\title{Load a bundled icon dataset}
\usage{
ggicon_data(icon, max_points = Inf, refresh = FALSE)
}
\arguments{
\item{icon}{One icon name returned by \code{ggicon_names()}.}
\item{max_points}{Maximum coordinate rows to return. \code{Inf} preserves the
original data.}
\item{refresh}{Reload the CSV instead of using the in-session cache.}
}
\value{A data frame containing at least numeric \code{x} and \code{y} columns.}
\description{
Loads and validates a bundled coordinate dataset. Point limiting is
deterministic and is useful for quickly previewing dense icons.
}
\examples{
mouse <- ggicon_data("mouse", max_points = 1000)
head(mouse)
}
