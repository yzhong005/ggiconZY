library(ggiconZY)

# This recreates the 12-row, A-H-column layout from the original script.
plate_read <- data.frame(column = 1:12)
for (row in LETTERS[1:8]) {
  plate_read[[row]] <- runif(12, 0.01, 1)
}

plate_values <- read_plate_reader(plate_read)
well_plate_plot(plate_values, show_values = TRUE)

# Files can be read directly as well:
# plate_values <- read_plate_reader(
#   "plate_reader_export.xlsx",
#   sheet = 1,
#   skip = 0
# )
