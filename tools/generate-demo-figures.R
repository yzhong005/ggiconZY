library(ggiconZY)
library(ggplot2)

figure_dir <- file.path("man", "figures")
dir.create(figure_dir, recursive = TRUE, showWarnings = FALSE)

save_plot <- function(filename, plot, width, height) {
  ggsave(
    file.path(figure_dir, filename),
    plot = plot,
    width = width,
    height = height,
    units = "in",
    dpi = 180,
    bg = "white"
  )
}

save_grid <- function(filename, plots, rows, columns, width, height) {
  grDevices::png(
    file.path(figure_dir, filename),
    width = width,
    height = height,
    units = "in",
    res = 180,
    bg = "white"
  )
  on.exit(grDevices::dev.off(), add = TRUE)
  grid::grid.newpage()
  layout <- grid::grid.layout(rows, columns)
  grid::pushViewport(grid::viewport(layout = layout))
  for (index in seq_along(plots)) {
    row <- ((index - 1L) %/% columns) + 1L
    column <- ((index - 1L) %% columns) + 1L
    print(
      plots[[index]],
      vp = grid::viewport(layout.pos.row = row, layout.pos.col = column)
    )
  }
  grid::popViewport()
  grDevices::dev.off()
  on.exit(NULL, add = FALSE)
}

demo_theme <- theme(
  plot.title = element_text(face = "bold", size = 12, hjust = 0.5),
  plot.margin = margin(8, 8, 8, 8)
)

icon_colours <- c(
  drosophila = "#7A5195",
  male = "#2F4B7C",
  mouse = "#58508D",
  panda = "#111111",
  singapore = "#D62728"
)

icon_plots <- lapply(ggicon_names(), function(icon) {
  ggicon_plot(
    icon,
    colour = unname(icon_colours[[icon]]),
    max_points = 30000
  ) +
    labs(title = tools::toTitleCase(icon)) +
    demo_theme
})

save_grid(
  "demo-icon-gallery.png",
  icon_plots,
  rows = 2,
  columns = 3,
  width = 10,
  height = 6.5
)

set.seed(123)
observations <- data.frame(
  x = sample(1:100, 30),
  y = sample(150:400, 30),
  group = rep(LETTERS[1:3], 10)
)

annotation_plot <- ggplot(observations, aes(x, y, colour = group)) +
  geom_point(size = 3) +
  annotation_ggicon(
    "mouse",
    xmin = 0,
    xmax = 25,
    ymin = 335,
    ymax = 405,
    max_points = 20000
  ) +
  labs(title = "Mouse icon embedded in an experimental plot") +
  theme_classic() +
  theme(plot.title = element_text(face = "bold"))

save_plot("demo-point-mouse.png", annotation_plot, 8, 5)

streak_plot <- culture_plate_plot(
  "streak",
  medium_colour = "#B24745",
  culture_colour = "#8F7700"
) +
  labs(title = "Streak plate with colonies") +
  demo_theme

disc_plot <- culture_plate_plot(
  "disc",
  labels = c("TZP", "AMC", "MEM", "CTX", "TGC", "NEW"),
  inhibition = c(0.20, 0.10, 0.25, 0, 0.15, 0.18),
  isolate_id = "Isolate 01"
) +
  labs(title = "Antimicrobial disc-diffusion plate") +
  demo_theme

save_plot("demo-culture-streak.png", streak_plot, 5.5, 5.5)
save_plot("demo-culture-disc.png", disc_plot, 5.5, 5.5)

set.seed(42)
assay_values <- matrix(
  rep(seq(0, 1, length.out = 12), times = 8) + rnorm(96, sd = 0.06),
  nrow = 8,
  byrow = TRUE
)

well_plot <- well_plate_plot(
  assay_values,
  palette = c("#FFF7EC", "#7F0000")
) +
  labs(title = "96-well assay overview") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

save_plot("demo-96-well-plate.png", well_plot, 10, 6.5)

plate_labels <- matrix("", nrow = 8, ncol = 12)
plate_labels[, 1] <- "B"
plate_labels[, 2] <- "C"
plate_labels[, 3:12] <- paste0("S", rep(1:10, each = 8))

labelled_well_plot <- well_plate_plot(
  labels = plate_labels,
  plate_colour = "#F5F7FA",
  well_colour = "#4B5563"
) +
  labs(title = "Labelled 96-well plate map") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

save_plot("demo-96-well-layout.png", labelled_well_plot, 10, 6.5)

overview_plots <- list(
  icon_plots[[which(ggicon_names() == "mouse")]] + labs(title = "Scientific icon"),
  annotation_plot + labs(title = "Icon annotation"),
  streak_plot,
  disc_plot,
  well_plot,
  labelled_well_plot
)

save_grid(
  "demo-package-overview.png",
  overview_plots,
  rows = 3,
  columns = 2,
  width = 12,
  height = 15
)
