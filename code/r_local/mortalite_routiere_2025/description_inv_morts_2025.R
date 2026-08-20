#install.packages("xtable")
library("xtable")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025")


effort <- read.csv("clean_road_2025.csv",
         header = TRUE,
         sep = ",",
         fileEncoding = "utf-8")

# Ajout d'une colonne pour la durée de l'échantillonnage

effort$time <- as.numeric((difftime(effort$fin, effort$debut, units = "mins")))

tapply(effort$tr, effort$protocol, function(x) length(unique(x)))


table(effort$tr)

