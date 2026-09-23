
setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere")

mort25 <- read.csv("inv_road_2025.csv", 
                   header = TRUE,
                   sep = ",",
                   fileEncoding = "utf-8")

length(mort25$orientation_gopro[mort25$orientation_gopro=="accotement"])

cat_2025 <- read.csv("cat_2025.csv",
                     header = TRUE,
                     sep = ";",
                     fileEncoding = "utf-8")

colnames(mort25)

# retrait des colonnes qui ne servent à rien

mort25_clean <- mort25[, !(names(mort25)) %in% c("sens",
                                                  "passage_num",
                                                 "vitesse",
                                                 "effort_gopro",
                                                 "couv_nuage",
                                                 "temp_air",
                                                  "vent",
                                                  "nom_fichier",
                                                 "initiales","commentaires")]

mort25_clean$technique <- ifelse(mort25_clean$technique == "pied", "P", 
                              ifelse(mort25_clean$technique == "drone", "D", "G"))

mort25_clean$date <- as.Date(mort25_clean$date)

mort25_clean$tr_id <- paste(format(mort25_clean$date, "%Y%m%d"),
                            mort25_clean$troncon, 
                            mort25_clean$technique, 
                            sep = "_")

# Conversion format des heures en H:M UTC pour calcul éventuel de l'effort plus tard

mort25_clean$hm1 <- as.POSIXct(paste(mort25_clean$date, 
                                             mort25_clean$heure_debut), 
                                             format = "%Y-%m-%d %H:%M", 
                                             tz = "America/Toronto")
mort25_clean$hm2 <- as.POSIXct(paste(mort25_clean$date, 
                                     mort25_clean$heure_fin), 
                               format = "%Y-%m-%d %H:%M", 
                               tz = "America/Toronto")

                                       
                                       
mort25_clean2 <- mort25_clean[, !(names(mort25_clean)) %in% c("heure_debut",
                                                 "heure_fin")]

mort25_clean2$effort_min <- as.numeric(difftime(mort25_clean2$hm2,
                                                mort25_clean2$hm1))

names(mort25_clean2) <- c("date","tr","type","km","method","orientation","tr_id","hm1","hm2","min")


mort25_clean2$tr_glob <- sub("_[EONS]$", "", mort25_clean2$tr)



mort25_cat <- merge(mort25_clean2, cat_2025, by = "tr_glob")


mort25_cat$min[which(is.na(mort25_cat$min) & mort25_cat$method == "G")] <- 1


write.csv(mort25_cat, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere/inv_road_2025_clean.csv",
          row.names = FALSE)





