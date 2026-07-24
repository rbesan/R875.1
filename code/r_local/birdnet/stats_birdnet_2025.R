###################################################################
# Script R rapport 3 R875.1
# Auteur : Robin Besançon
# Objectif : exploration des données d'audiomoths pour 2025
###################################################################

# Dépendences
#install.packages("gtools")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/output/csv_validation_birdnet")

table_birdnet_2025 <- rbind(
  read.csv("validation_birdnet_2025.csv"),
  read.csv("validation_mod9_2025.csv"))

# Renommage des espèces
table_birdnet_2025$species <- factor(table_birdnet_2025$species,
                                     levels = c("Striped Chorus Frog","Gray Treefrog","Spring Peeper", "Pickerel Frog", "Wood Frog", "Green Frog",
                                                "American Toad", "American Bullfrog", "PIPIENS", "SEPTENTRIONALIS"),
                                     labels = c("P. maculata","H. versicolor", "P. crucifer", "L. palustris", "L. sylvaticus", "L. clamitans",
                                                "A. americanus", "L. catesbeianus", "L. pipiens", "L. septentrionalis"))


table_birdnet_2025$site <- factor(table_birdnet_2025$site, levels = c("T01", 
                                                                      "T20",
                                                                      "T41_N1",
                                                                      "T42_N2",
                                                                      "T42_N3",
                                                                      "T42_S2",
                                                                      "T42_S3",
                                                                      "T47_1",
                                                                      "T47_2",
                                                                      "T47_3",
                                                                      "T48",
                                                                      "T49_1",
                                                                      "T49_2",
                                                                      "T52",
                                                                      "T57",
                                                                      "T65"))

tab_dataframe_birdnet_2025 <- as.data.frame(xtabs(val~site+species, data = table_birdnet_2025))

barplot1 <- tapply(tab_dataframe_birdnet_2025$Freq, tab_dataframe_birdnet_2025$species, sum)

barplot2 <- data.frame(species = names(barplot1),
                       clips = as.vector(barplot1))

barplot3 <- barplot2[order(barplot2$clips), ]

par(mar = c(4.5, 8, 1, 2))
barplot(barplot3$clips, names.arg = barplot3$species, horiz = TRUE, las = 1,
        col = "grey90", border = "grey40",
        xlab = "Nombre de clips (3s) birdnet validés en 2025")