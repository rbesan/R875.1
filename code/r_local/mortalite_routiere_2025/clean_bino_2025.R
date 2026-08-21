# Fonction : formatage des données de décomptes de carcasses à pied

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere_2025")

carca_raw <- read.csv("bino_carcasses.csv", header =  TRUE, sep = ",")

cat_25 <- read.csv("troncons_cat_2026.csv", header =  TRUE, sep = ",")

carca_raw_select <- carca_raw[,!names(carca_raw) %in% c("Num_waypoint...numéro.ou.nom.du.point.GPS.pris.lors.de.la.sortie",
                                                        "Num_.waypoint",
                                                        "X.1",
                                                        "X",
                                                        "Notes")]

carca_raw_select$Classe <- trimws(carca_raw_select$Classe)
carca_raw_select$Classe[carca_raw_select$Classe == "mammalia"] <- "Mammalia"
carca_raw_select$Classe[is.na(carca_raw_select$Classe)] <- "Ind"

carca_raw_select$Classe <- factor(carca_raw_select$Classe, levels = c("Anura",
                                                                      "Aves",
                                                                      "Mammalia",
                                                                      "Reptilia",
                                                                      "Ind"),
                                  labels = c("Anoures",
                                             "Oiseaux",
                                             "Mammifères",
                                             "Reptiles",
                                             "Indéterminés"))

carca_raw_select$Espece <- factor(carca_raw_select$Espece, levels = c("Lithobates pipiens",
                                                                      "Chrysemys picta", 
                                                                      "Sciurus carolinensis",
                                                                      "Felis catus",
                                                                      "Chelydra serpentina",
                                                                      "Thamnophis sirtalis",
                                                                      "Storeria occipitomaculata",
                                                                      "Procyon lotor",
                                                                      "Spinus tristis",
                                                                      "Ondatra zibethicus",
                                                                      "Mephitis mephitis",
                                                                      "Lithobates clamitans",
                                                                      "Marmota monax",
                                                                      "Cardinalis cardinalis"))


names(carca_raw_select)[names(carca_raw_select)=="Site"] <- "tr"
names(cat_25)[names(cat_25)=="troncon_id"] <- "tr"
cat_25$tr <- sprintf("T%02d", as.integer(cat_25$tr))
carca_raw_select$tr <- sprintf("T%02d", as.integer(sub("T", "", carca_raw_select$tr)))

carca25_clean <- merge(carca_raw_select, cat_25, by="tr", all.x = TRUE, sort = FALSE)

write.csv(carca25_clean, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025/clean_bino_2025.csv",
          row.names = FALSE)


