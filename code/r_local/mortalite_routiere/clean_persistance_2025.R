# Objectif : 


setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere_2025")

persi_rw <- read.csv("persistance_2025.csv", header = TRUE, sep = ",")

persi_select1 <- persi_rw[, !names(persi_rw) %in% c("name",
                                                    "laps",
                                                    "photo",
                                                    "rain",
                                                    "com_rain",
                                                    "x",
                                                    "y",
                                                    "commentaires", "X")]

persi_select1$jour_pred[persi_select1$jour_pred == "IND"] <- NA
persi_select1$mois_pred[persi_select1$mois_pred == "IND"] <- NA
persi_select1$heure_pred[persi_select1$heure_pred == "IND"] <- NA

persi_select1$tps_pred_h <- as.numeric(difftime(
  as.POSIXct(paste(format(as.Date(persi_select1$date1), "%Y"),
                   persi_select1$mois_pred, persi_select1$jour_pred,
                   persi_select1$heure_pred),
             format = "%Y %m %d %H:%M:%S", tz = "UTC"),
  as.POSIXct(paste(persi_select1$date1, persi_select1$heure1), tz = "UTC"),
  units = "hours"))

persi_select1$tps_test <- as.numeric(difftime(as.POSIXct(paste(persi_select1$date2, persi_select1$heure2), tz="UTC"),
                                              as.POSIXct(paste(persi_select1$date1, persi_select1$heure1), tz="UTC"), units = "hours"))

write.csv(persi_select1, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025/clean_persistance_2025.csv",
          row.names = FALSE)
