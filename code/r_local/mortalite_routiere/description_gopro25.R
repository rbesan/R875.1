setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025")


gopro_clean_2025 <- read.csv("clean_gopro_2025.csv",
                           header = TRUE,
                           sep = ",",
                           fileEncoding = "utf-8")
cat_2025 <- read.csv("cat_2025.csv",
                             header = TRUE,
                             sep = ";",
                             fileEncoding = "utf-8")

gopro_dead_2025 <- gopro_clean_2025[gopro_clean_2025$Etat=="mort",]


df_gopro_2025 <- as.data.frame(table(gopro_dead_2025$Tronçon))
names(df_gopro_2025) <- c("tr","obs")


merge_cat_2025 <- merge(cat_2025, df_gopro_2025, by="tr", all.x = TRUE)

merge_cat_2025$obs[is.na(merge_cat_2025$obs)] <- 0




