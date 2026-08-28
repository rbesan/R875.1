
setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere_2025")

tr_cat <- read.csv("troncons_cat_2026.csv", 
                   header = TRUE,
                   sep = ",",
                   fileEncoding = "utf-8")

names(tr_cat)[names(tr_cat)=="troncon_id"] <- "tr"
tr_cat$tr <- sprintf("T%02d", as.integer(tr_cat$tr))


write.csv(tr_cat, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025/clean_tr_cat.csv",
          row.names = FALSE)