library(sf)
library(tmap)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune")


cam24 <- st_read("CAM_autoroute.shp")

cam24 <- st_transform(cam24, 2950)

# Emprise du composeur

aera_cam24 <- st_bbox(st_buffer(st_as_sfc(st_bbox(cam24)),500))


# Montage de la carte 

cam24$dx <- ifelse(substr(cam24$Nom, 1, 3) == "CAS", -1.8, 1.8)

map_cam24 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(cam24, bbox = aera_cam24) +
  tm_symbols(shape = 21, fill = "red", col = "white", lwd = 0.8, size = 0.4) +
  tm_text("Nom", 
          size = 0.4, 
          col = "black", 
          xmod = "dx", 
          fontface = "bold",
          bgcol = "white", 
          bgcol_alpha = 0.3,) + 
  tm_scalebar(position=c("right","bottom"), breaks = c(0,1,2), text.size=0.7, lwd = 0.3)+
  tm_compass(type = "arrow", position = c("right", "top"), size = 2,
             color.dark = "black", lwd = 1)
# Exportation de la carte en png

tmap_save(map_cam24,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_cam24.png",
          width = 16.5, units = "cm", dpi = 300)