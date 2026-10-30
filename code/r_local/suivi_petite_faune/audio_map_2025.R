library(sf)
library(tmap)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune/")

# Importation de la table de suivi des caméras en 2025

audio25_csv <- read.csv("audio_2025.csv", header = TRUE, sep = ";")


# Transformation de la table en objet spatial 

audio25_sf <- st_as_sf(audio25_csv, coords = c("longitude","latitude"), crs = 4326)


# Transformation en MTM zone 8

audio25_sf_2950 <- st_transform(audio25_sf, 2950)

# Emprise du composeur

aera_audio25 <- st_bbox(st_buffer(st_as_sfc(st_bbox(audio25_sf_2950)),5000))

# Montage de la carte 

amas_ids <- c("T41_N1", "T42_N2", "T42_N3", "T42_S1", "T42_S2", "T42_S3",
              "T47_1", "T47_2", "T47_3", "T49_1", "T49_2")

audio25_sf_2950$lab <- audio25_sf_2950$ID
audio25_sf_2950$lab[audio25_sf_2950$ID %in% amas_ids] <- ""

amas_audio25 <- audio25_sf_2950[audio25_sf_2950$ID %in% amas_ids, ]
bbox_zoom    <- st_bbox(st_buffer(amas_audio25, 1500))
frame_zoom   <- st_sf(geometry = st_as_sfc(bbox_zoom))

# Carte générale : groupe encadré, sans étiquettes

map_audio25 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(audio25_sf_2950, bbox = aera_audio25) +
  tm_symbols(shape = 21, fill = "red", col = "white", lwd = 0.8, size = 0.4) +
  tm_text("lab", 
          bgcol = "white", 
          bgcol_alpha = 0.3,
          size = 0.6, 
          col = "black", 
          fontface = "bold",
          xmod = 0.6, 
          options = opt_tm_text(just = "left")) +
  tm_shape(frame_zoom) +
  tm_borders(col = "red", lwd = 2) +
  tm_compass(type = "arrow", position = c("left", "top"), size = 2,
             color.dark = "black", lwd = 1) +
  tm_scalebar(position = c("right", "bottom"), breaks = c(0, 10, 20),
              text.size = 0.7, lwd = 0.3)

# Carte zoom : groupe avec étiquettes
droite <- c("T41_N1", "T42_N2", "T42_N3", "T49_1")
gauche <- c("T42_S1", "T42_S2", "T42_S3", "T47_1", "T47_2", "T47_3", "T49_2")

map_zoomA25 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(amas_audio25, bbox = bbox_zoom) +
  tm_symbols(shape = 21, fill = "red", col = "white", lwd = 0.8, size = 0.6) +
  tm_shape(amas_audio25[amas_audio25$ID %in% droite, ]) +
  tm_text("ID", 
          size = 0.4, 
          bgcol = "white", 
          bgcol_alpha = 0.3,
          fontface = "bold", 
          xmod = 0.7,
          options = opt_tm_text(just = "left")) +
  tm_shape(amas_audio25[amas_audio25$ID %in% gauche, ]) +
  tm_text("ID", 
          size = 0.4, 
          bgcol = "white", 
          bgcol_alpha = 0.3,
          fontface = "bold", 
          xmod = -0.7,
          options = opt_tm_text(just = "right")) +
  tm_scalebar(position = c("left", "bottom"), 
              breaks = c(0, 1, 2),
              text.size = 0.7, lwd = 0.3) +
  tm_compass(type = "arrow", 
             position = c("left","top"), 
             size = 2,
             color.dark = "black", 
             lwd = 1) 

tmap_save(map_audio25,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_audio25.png",
          width = 16.5, units = "cm", dpi = 300)

tmap_save(map_zoomA25,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_zoomA25.png",
          width = 16.5, units = "cm", dpi = 300)
