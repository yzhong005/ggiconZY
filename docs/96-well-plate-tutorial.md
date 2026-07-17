# Plotting 96-well plates with ggiconZY

`well_plate_plot()` draws a standard microplate with rows A-H and columns 1-12.
It can show an empty experimental layout, custom well labels, or numeric assay
results as a heatmap.

## Install and load the package

```r
remotes::install_github("yzhong005/ggiconZY")

library(ggiconZY)
library(ggplot2)
```

## Start with a blank plate

```r
well_plate_plot()
```

Blank wells are white by default. Change the physical plate appearance without
adding assay data:

```r
well_plate_plot(
  plate_colour = "#e8eef3",
  well_colour = "#40566b",
  na_colour = "#ffffff"
)
```

## Read a plate-reader export

Use `read_plate_reader()` to convert an instrument export into the 8 by 12
matrix expected by `well_plate_plot()`:

```r
plate_values <- read_plate_reader(
  "plate_reader_export.xlsx",
  sheet = 1,
  skip = 0
)

well_plate_plot(plate_values, show_values = TRUE)
```

Excel input uses the `readxl` package. Install it once if necessary:

```r
install.packages("readxl")
```

The importer automatically recognizes three common layouts:

1. **Plate columns**, matching the original ggiconZY workflow: 12 records
   identified by 1-12, with measurement columns named A-H.
2. **Plate rows**: eight records identified by A-H, with measurement columns
   named 1-12.
3. **Long data**: a `Well` field containing IDs such as A1 and H12, plus a
   numeric measurement field.

The original transposed plate-reader table can also be passed directly:

```r
plate_read <- data.frame(column = 1:12)
for (row in LETTERS[1:8]) {
  plate_read[[row]] <- runif(12, 0.01, 1)
}

plate_values <- read_plate_reader(plate_read)
well_plate_plot(plate_values, show_values = TRUE)
```

If the workbook contains instrument information above the table, set `skip`
to the number of metadata rows. Select a different worksheet with `sheet`.

Long exports sometimes include several numeric measurements, such as time,
absorbance, and fluorescence. Select the one to plot explicitly:

```r
plate_values <- read_plate_reader(
  "kinetic_export.csv",
  layout = "long",
  value_column = "OD600"
)
```

## Map numeric results

Supply either an 8 by 12 numeric matrix or a numeric vector of length 96.
Matrix row 1 is plate row A. Vectors are read across the plate: A1-A12,
B1-B12, and so on through H12.

```r
set.seed(42)
assay_values <- matrix(
  rep(seq(0, 1, length.out = 12), times = 8) + rnorm(96, sd = 0.06),
  nrow = 8,
  byrow = TRUE
)

well_plate_plot(
  assay_values,
  palette = c("#fff7ec", "#7f0000")
) +
  labs(title = "96-well assay overview")
```

![Example 96-well assay heatmap](../man/figures/demo-96-well-plate.png)

Use `NA` for wells that were not measured; these use `na_colour`.

```r
assay_values[1, 1:3] <- NA

well_plate_plot(
  assay_values,
  na_colour = "grey85",
  palette = c("#edf8fb", "#006d2c")
)
```

## Add controls and well labels

Labels follow the same 8 by 12 or length-96 layout. Empty strings leave wells
unlabelled.

```r
control_labels <- matrix("", nrow = 8, ncol = 12)
control_labels[1, 1:3] <- c("Blank", "Neg", "Pos")
control_labels[8, 12] <- "QC"

well_plate_plot(
  values = assay_values,
  labels = control_labels,
  palette = c("#ffffcc", "#800026")
)
```

For small numeric datasets, `show_values = TRUE` prints the measurements in
the wells. Reduce `value_digits` when labels become crowded.

```r
well_plate_plot(
  values = round(assay_values, 2),
  show_values = TRUE,
  value_digits = 2,
  well_size = 10
)
```

## Combine with normal ggplot2 layers

The function returns a regular ggplot object, so titles and themes can be
added normally:

```r
well_plate_plot(assay_values) +
  labs(
    title = "Screening plate 01",
    subtitle = "Normalized fluorescence",
    caption = "Rows A-H; columns 1-12"
  ) +
  theme(plot.title = element_text(face = "bold"))
```
