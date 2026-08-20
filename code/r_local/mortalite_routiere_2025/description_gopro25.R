setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025")


gopro_clean_2025 <- read.csv("clean_gopro_2025.csv",
                           header = TRUE,
                           sep = ",",
                           fileEncoding = "utf-8")