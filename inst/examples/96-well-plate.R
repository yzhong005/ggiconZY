library(ggiconZY)
library(ggplot2)

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
