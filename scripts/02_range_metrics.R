# =============================================================================
# IMPORTANT METHODOLOGICAL DISCLAIMER
#
# This workflow does NOT implement the standard IUCN grid-based AOO (2 × 2 km).
# Area of Occupancy (AOO) is calculated here as the area of occupied hydrographic
# units (HydroBASINS level 8), which is equivalent to the distribution area.
#
# This approach is appropriate for regional assessments of freshwater taxa
# structured by drainage systems, but should not be directly compared to
# grid-based IUCN AOO estimates.
# =============================================================================

# =============================================================================
# 02 - Range metrics calculation
# =============================================================================

library(tidyverse)
library(sf)
library(sp)
library(rgdal)

sf::sf_use_s2(FALSE)

# Paths -----------------------------------------------------------------------

occ_data     <- "outputs/summary/occurrences_filtered.csv"
ceara_shp    <- "data/spatial/ceara.shp"
hydrobasins  <- "data/spatial/hydrobasins_8.shp"
crs_ref      <- "data/spatial/crs_reference.shp"

# Load data -------------------------------------------------------------------

dados <- read.csv(occ_data, sep = ";", fileEncoding = "latin1")

crsWGS84 <- st_crs(st_read(crs_ref, quiet = TRUE))

ce_shp <- st_read(ceara_shp, quiet = TRUE) %>%
  st_transform(crsWGS84)

hydro <- st_read(hydrobasins, quiet = TRUE) %>%
  st_transform(crsWGS84)

# Split by species ------------------------------------------------------------

spp <- unique(dados$especie)
dados_por_spp <- split(dados, dados$especie)

# Output vectors --------------------------------------------------------------

dist_area <- eoo_area <- aoo_area <- numeric(length(spp))

# Loop ------------------------------------------------------------------------

for (i in seq_along(spp)) {
  
  spp_name <- spp[i]
  spp_dir  <- file.path("outputs/species", gsub(" ", "_", spp_name))
  
  dir.create(spp_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(spp_dir, "shp"), showWarnings = FALSE)
  
  occ_shp <- st_as_sf(
    dados_por_spp[[i]],
    coords = c("lon", "lat"),
    crs = crsWGS84
  )
  
  # Distribution area ---------------------------------------------------------
  
  dist <- hydro[st_intersects(hydro, occ_shp, sparse = FALSE), ]
  dist$dissolve <- 1
  dist <- dist %>% group_by(dissolve) %>% summarize()
  
  dist_area[i] <- as.numeric(st_area(dist) / 1e6)
  
  # EOO -----------------------------------------------------------------------
  
  eoo <- st_convex_hull(dist)
  eoo <- st_crop(eoo, ce_shp)
  
  eoo_area[i] <- as.numeric(st_area(eoo) / 1e6)
  
  # AOO (hydrographic units) --------------------------------------------------
  
  aoo <- dist
  aoo_area[i] <- dist_area[i]
  
  # Export --------------------------------------------------------------------
  
  st_write(occ_shp, file.path(spp_dir, "shp", "occ.shp"), append = FALSE)
  st_write(dist,    file.path(spp_dir, "shp", "aod.shp"), append = FALSE)
  st_write(eoo,     file.path(spp_dir, "shp", "eoo.shp"), append = FALSE)
  st_write(aoo,     file.path(spp_dir, "shp", "aoo.shp"), append = FALSE)
}

# Summary table ---------------------------------------------------------------

summary_df <- data.frame(
  especie = spp,
  area_distribuicao_km2 = dist_area,
  eoo_km2 = eoo_area,
  aoo_km2 = aoo_area
)

write.table(
  summary_df,
  "outputs/summary/species_range_metrics.csv",
  sep = ";",
  row.names = FALSE
)
