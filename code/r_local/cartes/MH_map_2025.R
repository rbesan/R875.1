library(sf)
library(tmap)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune/")

# Importation de la table de suivi des caméras en 2025

MH25_csv <- read.csv("MH_2025.csv", header = TRUE, sep = ",")


# Transformation de la table en objet spatial 

MH25_csv_sf <- st_as_sf(MH25_csv, coords = c("x","y"), crs = 4326)

# Transformation en MTM zone 8

MH25_csv_sf_2950 <- st_transform(MH25_csv_sf, 2950)

# Emprise du composeur

aera_MH25 <- st_bbox(st_buffer(st_as_sfc(st_bbox(MH25_csv_sf_2950)),5000))

# Montage de la carte 


amas_ids <- c("MH_T41", "MH_T41_2", "MH_T42_3", "MH_T42_4", "MH_T42_5",
              "MH_T47", "MH_T49", "MH_T49_2")


MH25_csv_sf_2950$lab <- MH25_csv_sf_2950$id
MH25_csv_sf_2950$lab[MH25_csv_sf_2950$id %in% amas_ids] <- ""

amas <- MH25_csv_sf_2950[MH25_csv_sf_2950$id %in% amas_ids, ]
bbox_zoom <- st_bbox(st_buffer(amas, 1500))
frame_zoom <- st_sf(geometry = st_as_sfc(bbox_zoom))

map_MH25 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(MH25_csv_sf_2950, bbox = aera_MH25) +
  tm_symbols(shape = 21, 
             fill = "red", 
             col = "white", 
             lwd = 0.8, 
             size = 0.4) +
  tm_text("lab",
          size = 0.6, 
          bgcol = "white",
          bgcol_alpha = 0.3,
          col = "black", 
          fontface = "bold", 
          xmod = 0.6, 
          options = opt_tm_text(just = "left")) +
  tm_shape(frame_zoom)+
  tm_borders(col = "red", lwd = 2) +
  tm_scalebar(position=c("left","bottom"), breaks = c(0,10,20), text.size=0.7, lwd = 0.3)+
  tm_compass(type = "arrow", position = c("left", "top"), size = 2,
             color.dark = "black", lwd = 1)

map_zooMH25 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(amas, bbox = bbox_zoom) +
  tm_symbols(shape = 21, 
             fill = "red", 
             col = "white", 
             lwd = 0.8, 
             size = 0.6) +
  tm_text("id", 
          size = 0.4,
          bgcol = "white",
          bgcol_alpha = 0.3,
          col = "black",
          fontface = "bold",
          xmod = 0.7, 
          options = opt_tm_text(just = "left")) +
  tm_scalebar(position = c("left", "bottom"), breaks = c(0, 1, 2),
              text.size = 0.7, lwd = 0.3) +
  tm_compass(type = "arrow", position = c("left", "top"), size = 2,
             color.dark = "black", lwd = 1)

# Exportation des cartes en png

tmap_save(map_MH25,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_MH25.png",
          width = 16.5, units = "cm", dpi = 300)

tmap_save(map_zooMH25,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_zooMH25.png",
          width = 16.5, units = "cm", dpi = 300)