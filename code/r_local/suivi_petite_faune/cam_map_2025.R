library(sf)
library(tmap)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune/")

# Importation de la table de suivi des caméras en 2025

cam25_csv <- read.csv("cameras_2025.csv", header = TRUE, sep = ",")

cam25_csv_nona <- cam25_csv[complete.cases(cam25_csv[,c("x","y")]),]

# Transformation de la table en objet spatial 

cam25_sf <- st_as_sf(cam25_csv_nona, coords = c("x","y"), crs = 4326)

# Transformation en MTM zone 8

cam25_sf_2950 <- st_transform(cam25_sf, 2950)

# Emprise du composeur

aera_cam25 <- st_bbox(st_buffer(st_as_sfc(st_bbox(cam25_sf_2950)),3000))

# Montage de la carte 
# Une ligne par identifiant pour les étiquettes
lab25 <- cam25_sf_2950[!duplicated(cam25_sf_2950$id), ]

lab25$dy <- 0
lab25$dy[lab25$id == "GT45"]   <- -0.6
lab25$dy[lab25$id == "GT45_2"] <-  0.6
lab25$dy[lab25$id == "T411"]   <-  1
lab25$dy[lab25$id == "T422"]   <- -1
lab25$dy[lab25$id == "GT47"]   <- -0.6
lab25$dy[lab25$id == "GT49"]   <-  0.6

map_cam25 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(cam25_sf_2950, bbox = aera_cam25) +
  tm_symbols(shape = 21, fill = "red", col = "white", lwd = 0.8, size = 0.4) +
  tm_shape(lab25) +
  tm_text("id", size = 0.35, col = "black", fontface = "bold",
          bgcol = "white", bgcol_alpha = 0.3,
          xmod = 0.7, ymod = "dy",
          options = opt_tm_text(just = "left")) +
  tm_scalebar(position = c("right", "bottom"), breaks = c(0, 10, 20),
              text.size = 0.7, lwd = 0.1) +
  tm_compass(type = "arrow", position = c("right", "top"), size = 2,
             color.dark = "black", lwd = 1)

# Exportation de la carte en png
tmap_save(map_cam25,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_cam25.png",
          width = 16.5, units = "cm", dpi = 300)