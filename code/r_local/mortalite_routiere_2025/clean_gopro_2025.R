
setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere_2025")


gopro_raw_2025 <- read.csv("inv_gopro_2025.csv",
                   header = TRUE,
                   sep = ";",
                   fileEncoding = "utf-8")

gopro_select_2025 <- gopro_raw_2025[,!names(gopro_raw_2025) %in% c("Nom_fichier",
                                                                   "Direction",
                                                                   "Minutage_obs",
                                                                   "Heure_obs",
                                                                   "Heure_obs",
                                                                   "Voie_obs",
                                                                   "Taille_obs",
                                                                   "Couleur_obs",
                                                                   "Taille_obs",
                                                                   "Couleur_obs",
                                                                   "Traits_identification",
                                                                   "Observateur_initiales",
                                                                   "Notes")]



write.csv(gopro_select_2025, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025/clean_gopro_2025.csv",
          row.names = FALSE)

