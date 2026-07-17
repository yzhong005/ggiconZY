\name{read_plate_reader}
\alias{read_plate_reader}
\title{Read a plate-reader export}
\usage{
read_plate_reader(file, sheet = 1, skip = 0,
  layout = c("auto", "plate_columns", "plate_rows", "long"),
  value_column = NULL)
}
\arguments{
\item{file}{Path to a CSV, TSV, TXT, XLS, or XLSX export, or an already
imported data frame.}
\item{sheet}{Excel sheet name or number.}
\item{skip}{Number of metadata rows before the table header.}
\item{layout}{Automatic detection, \code{"plate_columns"} for 12 records with
A-H measurement columns, \code{"plate_rows"} for eight records with columns
1-12, or \code{"long"} for Well/Value data.}
\item{value_column}{Measurement column name or number for long exports with
multiple numeric columns.}
}
\value{An 8 by 12 numeric matrix with rows A-H and columns 1-12.}
\description{
Reads common plate-reader export layouts and converts them to the matrix format
accepted by \code{well_plate_plot()}. Excel input requires the suggested
\code{readxl} package.
}
\examples{
plate_export <- data.frame(column = 1:12)
for (row in LETTERS[1:8]) plate_export[[row]] <- runif(12)

values <- read_plate_reader(plate_export)
well_plate_plot(values)
}
