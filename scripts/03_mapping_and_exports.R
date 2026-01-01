# =============================================================================
# 03 - Mapping
# =============================================================================

library(sf)
library(ggplot2)

ce_shp <- st_read("data/spatial/ceara.shp", quiet = TRUE)

species_dirs <- list.dirs("outputs/species", recursive = FALSE)

for (dir in species_dirs) {
  
  shp_dir <- file.path(dir, "shp")
  map_dir <- file.path(dir, "maps")
  
  dir.create(map_dir, showWarnings = FALSE)
  
  occ <- st_read(file.path(shp_dir, "occ.shp"), quiet = TRUE)
  aod <- st_read(file.path(shp_dir, "aod.shp"), quiet = TRUE)
  eoo <- st_read(file.path(shp_dir, "eoo.shp"), quiet = TRUE)
  aoo <- st_read(file.path(shp_dir, "aoo.shp"), quiet = TRUE)
  
  ggsave(
    file.path(map_dir, "occurrences.png"),
    ggplot() + geom_sf(data = ce_shp) + geom_sf(data = occ),
    width = 4, height = 5
  )
  
  ggsave(
    file.path(map_dir, "distribution_area.png"),
    ggplot() + geom_sf(data = ce_shp) + geom_sf(data = aod, fill = "red"),
    width = 4, height = 5
  )
  
  ggsave(
    file.path(map_dir, "eoo.png"),
    ggplot() + geom_sf(data = ce_shp) + geom_sf(data = eoo, fill = "green"),
    width = 4, height = 5
  )
  
  ggsave(
    file.path(map_dir, "aoo.png"),
    ggplot() + geom_sf(data = ce_shp) + geom_sf(data = aoo, fill = "green"),
    width = 4, height = 5
  )
}
