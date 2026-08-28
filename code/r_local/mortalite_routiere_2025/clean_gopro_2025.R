
setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere_2025")


gopro_raw_2025 <- read.csv("inv_gopro_2025.csv",
                   header = TRUE,
                   sep = ";",
                   fileEncoding = "utf-8")

gopro_select_2025 <- gopro_raw_2025[,!names(gopro_raw_2025) %in% c("Nom_fichier",
                                                                   "Direction",
                                                                   "Minutage_obs",
                                                                   "Taille_obs",
                                                                   "Couleur_obs",
                                                                   "Taille_obs",
                                                                   "Couleur_obs",
                                                                   "Traits_identification",
                                                                   "Observateur_initiales",
                                                                   "Notes")]
cat_2025 <- read.csv("cat_2025.csv",
                     header = TRUE,
                     sep = ";",
                     fileEncoding = "utf-8")

gopro_dead_2025 <- gopro_select_2025[gopro_select_2025$Etat=="mort",]


df_gopro_2025 <- as.data.frame(table(gopro_dead_2025$Tronçon, gopro_dead_2025$Taxon))
names(df_gopro_2025) <- c("tr","taxon_id","obs")

sub_gopro_2025 <- subset(df_gopro_2025, obs > 0)


merge_cat_2025 <- merge(cat_2025,sub_gopro_2025, by="tr", all.x = TRUE)

merge_cat_2025$obs[is.na(merge_cat_2025$obs)] <- 0

merge_cat_2025$group <- ifelse(merge_cat_2025$obs==1, "mammalia", NA)

merge_cat_2025$method <- "gopro"

write.csv(merge_cat_2025, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025/clean_gopro_2025.csv",
          row.names = FALSE)

