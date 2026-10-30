library(sf)
library(tmap)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere/")

# Importation de la table des tronçons

tr25_csv <- read.csv("troncons_cat_2026.csv", header = TRUE, sep = ";")

# Conversion des coordonnées en numérique (gère point ou virgule décimale)

for (v in c("x1", "y1", "x2", "y2")) {
  tr25_csv[[v]] <- as.numeric(gsub(",", ".", trimws(tr25_csv[[v]])))
}

# Transformation de la table en objet spatial (lignes début -> fin)

geom_tr25 <- lapply(seq_len(nrow(tr25_csv)), function(i) {
  st_linestring(matrix(c(tr25_csv$x1[i], tr25_csv$y1[i],
                         tr25_csv$x2[i], tr25_csv$y2[i]),
                       ncol = 2, byrow = TRUE))
})

tr25_csv_sf <- st_sf(tr25_csv, geometry = st_sfc(geom_tr25, crs = 4326))
tr25_csv_sf$categorie <- factor(tr25_csv_sf$categorie)

# Transformation en MTM zone 8

tr25_csv_sf_2950 <- st_transform(tr25_csv_sf, 2950)

# Milieux de tronçons pour les étiquettes

st_agr(tr25_csv_sf_2950) <- "constant"
tr25_mil_2950 <- st_centroid(tr25_csv_sf_2950)

# Emprise du composeur

aera_tr25 <- st_bbox(st_buffer(st_as_sfc(st_bbox(tr25_csv_sf_2950)), 5000))

# Montage de la carte

map_tr25 <- tm_basemap("Esri.WorldImagery", alpha = 0.5) +
  tm_shape(tr25_csv_sf_2950, bbox = aera_tr25) +
  tm_lines(col = "categorie", 
           lwd = 2,
           col.scale = tm_scale_categorical(values = c("0" = "#1b9e77",
                                                       "1" = "#d95f02",
                                                       "2" = "#7570b3")),
           col.legend = tm_legend(title = "Catégorie",
                                  position = tm_pos_in("right", "bottom"),
                                  bg.color = "white",
                                  bg.alpha = 0.7,
                                  frame = TRUE)) +
  tm_shape(tr25_mil_2950) +
  tm_text("troncon", 
          size = 0.4, 
          bgcol = "white",
          bgcol_alpha = 0.3,
          col = "black", 
          fontface = "bold",
          xmod = 0.6, 
          options = opt_tm_text(just = "left")) +
  tm_scalebar(position = c("left", "bottom"), breaks = c(0, 10, 20),
              text.size = 0.7, lwd = 0.3) +
  tm_compass(type = "arrow", position = c("left", "top"), size = 2,
             color.dark = "black", lwd = 1)

tmap_save(map_tr25,
          "/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/map_tr25.png",
          width = 16.5, units = "cm", dpi = 300)