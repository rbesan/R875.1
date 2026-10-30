library(sf)
library(tmap)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere/")

# Importation de la table de suivi des caméras en 2025

persi25_csv <- read.csv("persistance_2025.csv", header = TRUE, sep = ",")

persi25_csv_select <- persi25_csv[,!names(persi25_csv) %in% c("commentaires", "com_rain", "X")]

persi25_csv_nona <- persi25_csv_select[complete.cases(persi25_csv_select[,c("x","y")]),]

persi25_csv_nona$type <- factor(persi25_csv_nona$type, 
                           levels = c("autoroute", "secondaire"),
                           labels = c("Autoroute", "Route secondaire"))
# Transformation de la table en objet spatial 

persi25_sf <- st_as_sf(persi25_csv_nona, coords = c("x","y"), crs = 4326)


# Transformation en MTM zone 8

persi25_sf_2950 <- st_transform(persi25_sf, 2950)

# Emprise du composeur

aera_persi25 <- st_bbox(st_buffer(st_as_sfc(st_bbox(persi25_sf_2950)),5000))

# Montage de la carte 


map_persi25 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(persi25_sf_2950, bbox = aera_persi25) +
  tm_symbols(shape = 21, 
             fill = "type", 
             col = "white", 
             lwd = 0.8, 
             size = 0.3,
             fill.scale = tm_scale_categorical(values = "brewer.set1"),
             fill.legend = tm_legend(title = "Infrastructure",
                                     position = tm_pos_in("right", "top"),
                                     bg.color = "white", bg.alpha = 0.8)) +
    tm_compass(type = "arrow", position = c("right", "bottom"), size = 2,
             color.dark = "black", lwd = 1)+
  tm_scalebar(position=c("right","bottom"), breaks = c(0,10,20), text.size=0.7, lwd = 0.3)

# Exportation de la carte en png

tmap_save(map_persi25,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_persi25.png",
          width = 16.5, units = "cm", dpi = 300)