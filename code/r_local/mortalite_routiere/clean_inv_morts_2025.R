
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

mort25_camera <- subset(mort25_clean, mort25_clean$orientation_gopro == "route" | is.na(mort25_clean$orientation_gopro))

mort25_camera$date <- as.Date(mort25_camera$date)

mort25_camera$tr_id <- paste(format(mort25_camera$date, "%Y%m%d"),
                            mort25_camera$troncon, 
                            mort25_camera$technique, 
                            sep = "_")

# Conversion format des heures en H:M UTC pour calcul éventuel de l'effort plus tard

mort25_camera$hm1 <- as.POSIXct(paste(mort25_camera$date, 
                                      mort25_camera$heure_debut), 
                                             format = "%Y-%m-%d %H:%M", 
                                             tz = "America/Toronto")
mort25_camera$hm2 <- as.POSIXct(paste(mort25_camera$date, 
                                      mort25_camera$heure_fin), 
                               format = "%Y-%m-%d %H:%M", 
                               tz = "America/Toronto")

                                       
                                       
mort25_hm <- mort25_camera[, !(names(mort25_camera)) %in% c("heure_debut",
                                                 "heure_fin")]

mort25_hm$effort_min <- as.numeric(difftime(mort25_hm$hm2,
                                            mort25_hm$hm1))

names(mort25_hm) <- c("date","tr","type","km","method","orientation","tr_id","hm1","hm2","min")


mort25_hm$tr_glob <- sub("_[EONS]$", "", mort25_hm$tr)



mort25_cat <- merge(mort25_hm, cat_2025, by = "tr_glob")


mort25_cat$min[which(is.na(mort25_cat$min) & mort25_cat$method == "G")] <- 1



nb_method <- tapply(mort25_cat$method, mort25_cat$tr, function(x) length(unique(x)))
mort25_method <- mort25_cat[mort25_cat$tr %in% names(nb_method)[nb_method > 1], ]


mort25_method$method <- factor(mort25_method$method, 
                        levels = c("P","D","G"),
                        labels = c("À pied","Drone","GoPro"))


mort25_method$type <- factor(mort25_method$type, 
                      levels = c("autoroute","secondaire_etroite","secondaire_separee"),
                      labels = c("Autoroute","Secondaire étroite","Secondaire séparée"))



write.csv(mort25_method, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere/inv_road_2025_clean.csv",
          row.names = FALSE)





