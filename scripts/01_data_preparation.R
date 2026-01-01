# =============================================================================
# 01 - Data preparation
# =============================================================================

library(tidyverse)
library(sf)
library(sp)
library(rgdal)

# Paths -----------------------------------------------------------------------

data_raw   <- "data/raw/spp_coord_tombo_v4.csv"
ceara_shp  <- "data/spatial/ceara.shp"

# Load data -------------------------------------------------------------------

dados <- read.csv(
  data_raw,
  sep = ";",
  fileEncoding = "latin1"
)

dados$especie <- str_trim(dados$especie)

# Remove species with <= 2 occurrences ----------------------------------------

freq_spp <- table(dados$especie)
spp_excluir <- names(freq_spp[freq_spp <= 2])

dados_filtrados <- dados %>%
  filter(!especie %in% spp_excluir)

# Spatial filter: keep only points inside Ceará -------------------------------

ce_shp <- st_read(ceara_shp, quiet = TRUE) %>%
  st_transform(4326)

points <- st_as_sf(
  dados_filtrados,
  coords = c("lon", "lat"),
  crs = 4326
)

inside_ce <- st_within(points, ce_shp) %>% lengths() > 0
dados_filtrados <- dados_filtrados[inside_ce, ]

# Save clean data --------------------------------------------------------------

dir.create("outputs/summary", recursive = TRUE, showWarnings = FALSE)

write.table(
  dados_filtrados,
  "outputs/summary/occurrences_filtered.csv",
  sep = ";",
  row.names = FALSE,
  fileEncoding = "latin1"
)
