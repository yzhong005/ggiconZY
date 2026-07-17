library(ggiconZY)

# A streak plate with isolated colonies.
culture_plate_plot(
  "streak",
  medium_colour = "#b24745",
  culture_colour = "#8f7700"
)

# A disc-diffusion plate with configurable labels and inhibition zones.
culture_plate_plot(
  "disc",
  labels = c("TZP", "AMC", "MEM", "CTX", "TGC", "NEW"),
  inhibition = c(0.20, 0.10, 0.25, 0, 0.15, 0.18),
  isolate_id = "Isolate 01"
)
