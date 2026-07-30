library(sf)


setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/carto")

st_layers("Audiomoths_RMM_2025.kml")

kml_am25 <- st_read("Audiomoths_RMM_2025.kml", layer = "gpsaudiomoths2025")


coords_am25 <- st_coordinates(kml_am25)

data_coords_am25 <- data.frame(
  site = kml_am25$Name,
  lon  = coords_am25[, "X"],
  lat  = coords_am25[, "Y"]
)