library(ggiconZY)
library(ggplot2)

# 1. Standalone scientific icons
ggicon_plot("mouse", colour = "#333333", max_points = 20000)

# 2. A scientific icon embedded in another ggplot
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(colour = "#2166AC", size = 2.5) +
  annotation_ggicon(
    "mouse",
    xmin = 1.5,
    xmax = 2.5,
    ymin = 25,
    ymax = 35,
    max_points = 20000
  ) +
  theme_classic()

# 3. A streak plate with colonies
culture_plate_plot("streak")

# 4. An antimicrobial disc-diffusion plate
culture_plate_plot(
  "disc",
  labels = c("TZP", "AMC", "MEM", "CTX", "TGC", "NEW"),
  inhibition = c(0.20, 0.10, 0.25, 0, 0.15, 0.18),
  isolate_id = "Isolate 01"
)

# 5. A 96-well assay heatmap
set.seed(42)
assay_values <- matrix(rnorm(96, mean = 0.6, sd = 0.2), nrow = 8)
well_plate_plot(
  assay_values,
  palette = c("#FFF7EC", "#7F0000")
)
