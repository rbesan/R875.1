library(sf)
library(tmap)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune/")

# Importation de la table de suivi des caméras en 2025

plaques25_csv <- read.csv("plaques_2025.csv", header = TRUE, sep = ",")


plaques25_csv$cat <- factor(plaques25_csv$cat, 
                                levels = c("0", "1","2"))

# Transformation de la table en objet spatial 

plaques25_sf <- st_as_sf(plaques25_csv, coords = c("x","y"), crs = 4326)


# Transformation en MTM zone 8

plaques25_sf_2950 <- st_transform(plaques25_sf, 2950)

# Emprise du composeur

aera_plaques25 <- st_bbox(st_buffer(st_as_sfc(st_bbox(plaques25_sf_2950)),5000))

# Montage de la carte 


map_plaques25 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(plaques25_sf_2950, bbox = aera_plaques25) +
  tm_symbols(shape = 21, fill = "cat", col = "white", lwd = 2, size = 0.4,
             fill.scale = tm_scale_categorical(values = "brewer.set1"),
             fill.legend = tm_legend(title = "Type de tronçon",
                                     position = tm_pos_in("right", "top"),
                                     bg.color = "white", bg.alpha = 0.8)) +
  tm_compass(type = "arrow", position = c("right", "bottom"), size = 2,
             color.dark = "black", lwd = 1)+
  tm_scalebar(position=c("right","bottom"), breaks = c(0,10,20), text.size=0.7, lwd = 0.3)+
  tm_title("Localisation des plaques à reptiles
sur 22 tronçons en région métropolitaine de Montréal en 2025", size = 1.2, fontface = "bold", position = tm_pos_out("center","top"))

# Exportation de la carte en png

tmap_save(map_plaques25,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_plaques25.png",
          width = 20, height = 14, units = "cm", dpi = 300)