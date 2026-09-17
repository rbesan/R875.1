library(sf)
library(terra)
library(maptiles)
#install.packages("mapview")
library(mapview)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/carto")


## coordonnées des audiomoths 2025

kml_am25 <- st_read("Audiomoths_RMM_2025.kml", layer = "gpsaudiomoths2025")

kml_am25$Name <- c("T28", 
                           "T01",
                           "T41_N1",
                           "T42_N3",
                           "T57",
                           "T20",
                           "T48",
                           "T41_N2",
                           "T42_S1",
                           "T42_S2",
                           "T42_S3",
                           "T49_2",
                           "T49_1",
                           "T47_1",
                           "T47_2",
                           "T47_3",
                           "T52",
                           "T65")

record25 <- st_zm(kml_am25)

record25 <- st_transform(record25,32618)

secteur <- st_buffer(st_as_sfc(st_bbox(record25)), 3000)

mapview(record25)

## fond de carte orthophoto

ortho <- get_tiles(secteur, provider = "Esri.WorldImagery")
ortho <- project(ortho, "EPSG:32618")
ortho <- crop(ortho, vect(secteur))

## Figure 

# Fond et niveau de transparence
plotRGB(ortho, alpha=0.55, mar=c(2,1,1,1))

# Points (sites)

plot(st_geometry(record25), add=TRUE, pch=21, bg="#D7301F", col="white", lwd=1.2, cex=1.3)

d <- as.matrix(dist(st_coordinates(record25)))
isole <- apply(d, 1, function(x) sum(x < 1100) == 1)
text(st_coordinates(record25), labels = record25$Name, pos = 2, offset = 0.4, cex = 0.8, col = "grey15")

# Habillage 

cadre <- as.vector(ext(ortho))
rect(cadre[1],cadre[3],cadre[2],cadre[4])
sbar(10000, below = "km", labels = c(0,5,10), xy="topleft", cex=0.7)
north(type=2,d=2500)
mtext("Fond : Esri World Imagery", side = 1, line = 2, adj = 0.25, cex = 0.5, col = "white")

#Zoom 
avenant1 <- record25[!isole, ]
zoom1 <- st_buffer(st_as_sfc(st_bbox(avenant1)), 800)
plot(st_as_sfc(st_bbox(zoom1)), add = TRUE, border = "white", lwd = 1.5)

b <- st_bbox(zoom1)
text(b["xmin"], b["ymax"], "", col = "white", cex = 0.9, font = 2, pos = 3)


