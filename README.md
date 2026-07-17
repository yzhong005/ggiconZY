# ggiconZY

[![R-CMD-check](https://github.com/yzhong005/ggiconZY/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yzhong005/ggiconZY/actions/workflows/R-CMD-check.yaml)

`ggiconZY` is an R package for creating reusable microbiology and biological
illustrations with `ggplot2`. It draws scientific icons, bacterial culture
plates, disc-diffusion assays, and 96-well plate-reader results as customizable
ggplot objects.

<p align="center">
  <img src="man/figures/demo-package-overview.png" alt="Overview of all ggiconZY plot types" width="760">
</p>

## What ggiconZY can plot

| Plot type | Function | Current options |
|---|---|---|
| Scientific icons | `ggicon_plot()` | Drosophila, male symbol, mouse, panda, and Singapore silhouette |
| Icons inside other graphs | `annotation_ggicon()` | Position and resize any bundled icon in ggplot data coordinates |
| Bacterial culture plates | `culture_plate_plot()` | Streak plates with colonies or disc-diffusion plates with inhibition zones |
| 96-well microplates | `well_plate_plot()` | Blank maps, custom labels, assay heatmaps, displayed values, and missing wells |

The package also includes `read_plate_reader()` for importing CSV, text, and
Excel plate-reader exports, and `ggicon_data()` for accessing raw icon
coordinates. See the [complete package tutorial](docs/package-tutorial.md) for
every function, demo figure, customization option, and runnable example.

## Installation

Install the development version from GitHub:

```r
install.packages("remotes")
remotes::install_github("yzhong005/ggiconZY")
```

## Quick examples

### Available icons

```r
library(ggiconZY)

ggicon_names()
#> [1] "drosophila" "male" "mouse" "panda" "singapore"
```

Load the original coordinates when you want full control:

```r
mouse <- ggicon_data("mouse")
head(mouse)
```

For a quick preview of a dense icon, limit the number of plotted points:

```r
ggicon_plot("panda", colour = "#1B1B1B", max_points = 30000)
```

<p align="center">
  <img src="man/figures/demo-icon-gallery.png" alt="Gallery of every bundled scientific icon" width="700">
</p>

### Add an icon to a ggplot

```r
library(ggplot2)

set.seed(123)
observations <- data.frame(
  x = sample(1:100, 30),
  y = sample(150:400, 30),
  group = rep(LETTERS[1:3], 10)
)

ggplot(observations, aes(x, y, colour = group)) +
  geom_point(size = 3) +
  annotation_ggicon(
    "mouse",
    xmin = 0,
    xmax = 25,
    ymin = 335,
    ymax = 405,
    max_points = 20000
  ) +
  theme_classic()
```

<p align="center">
  <img src="man/figures/demo-point-mouse.png" alt="Mouse icon embedded in a point plot" width="620">
</p>

`annotation_ggicon()` uses the parent plot's data coordinates. Adjust `xmin`,
`xmax`, `ymin`, and `ymax` to control its position and size.

### Draw a bacterial streak plate

```r
culture_plate_plot("streak")
```

<p align="center">
  <img src="man/figures/demo-culture-streak.png" alt="Bacterial streak plate" width="420">
</p>

### Draw an antimicrobial disc-diffusion plate

```r
culture_plate_plot(
  "disc",
  labels = c("TZP", "AMC", "MEM", "CTX", "TGC", "NEW"),
  inhibition = c(0.20, 0.10, 0.25, 0, 0.15, 0.18),
  isolate_id = "Isolate 01"
)
```

<p align="center">
  <img src="man/figures/demo-culture-disc.png" alt="Antimicrobial disc-diffusion plate" width="420">
</p>

Both the agar and culture colours are customizable. Disc labels, inhibition
zones, and the isolate identifier can also be changed.

### Plot a 96-well plate

Read a plate-reader export directly, then pass the standardized matrix to the
plot function:

```r
plate_values <- read_plate_reader(
  "plate_reader_export.xlsx",
  sheet = 1,
  skip = 0
)

well_plate_plot(plate_values, show_values = TRUE)
```

The importer recognizes the 12-row format used in the original ggiconZY code
(columns 1-12 with measurement fields A-H), the conventional A-H row format,
and long `Well`/`Value` tables. CSV, TSV, TXT, XLS, and XLSX files are supported.

To generate a simulated demonstration instead:

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
)
```

<p align="center">
  <img src="man/figures/demo-96-well-plate.png" alt="96-well assay heatmap" width="720">
</p>

To create a labelled experimental plate map instead:

```r
plate_labels <- matrix("", nrow = 8, ncol = 12)
plate_labels[, 1] <- "B"
plate_labels[, 2] <- "C"
plate_labels[, 3:12] <- paste0("S", rep(1:10, each = 8))

well_plate_plot(labels = plate_labels)
```

<p align="center">
  <img src="man/figures/demo-96-well-layout.png" alt="Labelled 96-well plate map" width="720">
</p>

Values can be an 8 by 12 matrix or a length-96 vector ordered A1 through A12,
then B1 through B12. See the
[96-well plate tutorial](docs/96-well-plate-tutorial.md) for controls, labels,
plate-reader imports, missing wells, and customization examples.

For a guided tour of the entire package, including all current plot types, see
the [complete ggiconZY tutorial](docs/package-tutorial.md).

## Contributing

Bug reports and new icon proposals are welcome. See
[CONTRIBUTING.md](CONTRIBUTING.md) for the expected data format and validation
steps.

## Citation

If you use `ggiconZY` in research, please cite:

> Zhong, Yang. (2023). *ggiconZY*. Version 1.0.0.
> <https://github.com/yzhong005/ggiconZY>

Citation metadata is also available in [CITATION.cff](CITATION.cff).

## License

MIT © Yang Zhong. See [LICENSE.md](LICENSE.md).
