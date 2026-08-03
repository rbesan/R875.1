


setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune_2025")


inv_mh_25_rw <- read.csv("inv_mh_2025.csv", header = TRUE, sep = ";")


inv_mh_25_select <- inv_mh_25_rw[, !names(inv_mh_25_rw) %in% c("EQUIPE",
                                                               "COMMENTAIRES",
                                                               "X",
                                                               "X.1",
                                                               "X.2",
                                                               "X.3",
                                                               "X.4",
                                                               "X...")]


inv_mh_25_select$ESPECE[grepl("poisson", inv_mh_25_select$ESPECE, ignore.case = TRUE)] <- "poisson"

inv_mh_25_select$ESPECE <- factor(inv_mh_25_select$ESPECE, levels = c("ANAM", 
                                                                  "Anura", 
                                                                  "poisson", 
                                                                  "BOLE", 
                                                                  "Ardea alba", 
                                                                  "Ardea herodias",
                                                                  "CHPI",
                                                                  "CHSE",
                                                                  "DRVE",
                                                                  "ecrevisse",
                                                                  "LICL",
                                                                  "LIPI",
                                                                  "LISY",
                                                                  "ODVI",
                                                                  "THSI",
                                                                  "Tortue sp", 
                                                                  "Indetermine"),
                                  labels = c("Crapaud d'Amérique", 
                                             "Anoures indéterminé", 
                                             "Poisson", 
                                             "Butor d'Amérique", 
                                             "Grande aigrette", 
                                             "Grand héron",
                                             "Tortue peinte",
                                             "Tortue serpentine",
                                             "Rainette versicolore",
                                             "Écrevisse",
                                             "Grenouille verte",
                                             "Grenouille léopard",
                                             "Grenouille des bois",
                                             "Cerf de virginie",
                                             "Couleuvre rayée",
                                             "Tortue Indéterminée", 
                                             "Amphibien indéterminé"))

inv_mh_25_amphibiens <- droplevels(subset(inv_mh_25_select, ESPECE %in% c(
  "Crapaud d'Amérique", "Anoures indéterminé", "Rainette versicolore",
  "Grenouille verte", "Grenouille léopard", "Grenouille des bois",
  "Amphibien indéterminé")))


# Transformer en presence/ absence 

inv_mh_25_amphibiens$NOMBRE <- as.numeric(inv_mh_25_amphibiens$NOMBRE)

# Retrait des NA

inv_mh_25_sansNA <- inv_mh_25_amphibiens[!is.na(inv_mh_25_amphibiens$NOMBRE), ]

sites <- unique(inv_mh_25_rw$MILIEU.HUMIDE)

str(inv_mh_25_sansNA)

inv_mh_25_sansNA$MILIEU.HUMIDE <- factor(trimws(inv_mh_25_sansNA$MILIEU.HUMIDE),
                                         levels = sites)

mat_amphibiens25 <- xtabs(NOMBRE ~ MILIEU.HUMIDE + ESPECE, data = inv_mh_25_sansNA)

bin_amphibiens25 <- ifelse(mat_amphibiens25> 0,1,0)

