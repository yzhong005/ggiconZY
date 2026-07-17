library(ggiconZY)
library(ggplot2)

# Draw an icon by itself.
ggicon_plot("mouse", colour = "#333333", max_points = 20000)

# Place the icon inside another plot.
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
