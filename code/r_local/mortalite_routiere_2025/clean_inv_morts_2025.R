
setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere_2025")

mort25 <- read.csv("inv_road_2025.csv", 
                   header = TRUE,
                   sep = ";",
                   fileEncoding = "utf-8")

# Suppression de tronçons suspects en GoPro

mort25 <- mort25[!(mort25$Troncons_ID %in% c(41, 42) &
                     mort25$Technique == "GoPro" &
                     mort25$Date_inv == "03/06/2025"), ]

# retrait des colonnes qui ne servent à rien

mort25_clean <- mort25[, !(names(mort25)) %in% c("Passage_num",
                                                  "Distance",
                                                  "Vitesse",
                                                  "Temp_air",
                                                  "Couv_nuage",
                                                  "Vent",
                                                  "Obs",
                                                  "commentaire", 
                                                  "Temp_air",
                                                  "Couv_nuage",
                                                  "Vent",
                                                  "Initiales",
                                                  "Nom_fichier",
                                                  "Vitesse",
                                                  "Commentaires",
                                                  "X",
                                                  "Passage_num...pour.le.drone.seulement..ID.du.passage.faunique.prévue.de.1.à.4",
                                                  "X.1",
                                                  "X.2",
                                                  "X.3",
                                                  "X.4",
                                                  "X.5",
                                                  "X.6",
                                                  "X.7",
                                                  "X.8",
                                                  "X.9",
                                                  "X.10",
                                                  "X.11",
                                                  "X.12",
                                                  "X.13")]




# Converstion format dates
mort25_clean$date <- format(as.Date(mort25_clean$Date_inv,
                                    format = "%d/%m/%Y"), "%Y-%m-%d")

# Conversion format des heures en H:M UTC pour calcul éventuel de l'effort plus tard

mort25_clean$hm1 <- as.POSIXct(paste(mort25_clean$date, 
                                             mort25_clean$Heure_debut), 
                                             format = "%Y-%m-%d %H:%M", 
                                             tz = "America/Toronto")
mort25_clean$hm2 <- as.POSIXct(paste(mort25_clean$date, 
                                     mort25_clean$Heure_fin), 
                               format = "%Y-%m-%d %H:%M", 
                               tz = "America/Toronto")

                                       
                                       
mort25_clean2 <- mort25_clean[, !(names(mort25_clean)) %in% c("Date_inv","Heure_debut","Heure_fin")]


names(mort25_clean2) <- c("tr","protocol","date","debut", "fin")

write.csv(mort25_clean2, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025/clean_road_2025.csv",
          row.names = FALSE)



