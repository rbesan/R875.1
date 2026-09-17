# Fonction : formatage des données de décomptes de carcasses à pied

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/mortalite_routiere_2025")

# table d'obs inventaire jumelles
carca_raw <- read.csv("bino_carcasses.csv", header =  TRUE, sep = ",")

# table d'obs inventaires gopro

gopro_raw_2025 <- read.csv("inv_gopro_2025.csv",
                           header = TRUE,
                           sep = ",",
                           fileEncoding = "utf-8")

carca_raw_select <- carca_raw[,!names(carca_raw) %in% c("waypoint",
                                                        "sens_obs",
                                                        "mortalite",
                                                        "revu",
                                                        "commentaires")]

carca_raw_select$classe[is.na(carca_raw_select$classe)] <- "Ind"

carca_raw_select$classe <- factor(carca_raw_select$classe, levels = c("amphibia",
                                                                      "aves",
                                                                      "mammalia",
                                                                      "reptilia",
                                                                      "Ind"),
                                  labels = c("Amphibiens",
                                             "Oiseaux",
                                             "Mammifères",
                                             "Reptiles",
                                             "Indéterminés"))

carca_raw_select$espece <- factor(carca_raw_select$espece, levels = c("Lithobates pipiens",
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



carca_raw_select$date <- as.Date(carca_raw_select$date)

names(carca_raw_select) <- c("tr",
                             "rang_id",
                             "class",
                             "order",
                             "family",
                             "genus",
                             "species",
                             "condition",
                             "loc",
                             "size",
                             "date",
                             "hour")

carca_raw_select$method <- "P"

carca_raw_select$tr_id <- paste(format(carca_raw_select$date, "%Y%m%d"),
                                carca_raw_select$tr,
                                carca_raw_select$method, 
                                sep = "_")



gopro_select_2025 <- gopro_raw_2025[,!names(gopro_raw_2025) %in% c("nom_fichier",
                                                                   "minutage_obs",
                                                                   "heure_obs",
                                                                   "emplacement",
                                                                   "taille_obs",
                                                                   "couleur_obs",
                                                                   "traits_identification",
                                                                   "observateur",
                                                                   "commentaires")]
cat_2025 <- read.csv("cat_2025.csv",
                     header = TRUE,
                     sep = ";",
                     fileEncoding = "utf-8")

gopro_dead_2025 <- gopro_select_2025[gopro_select_2025$etat=="mort",]


names(gopro_dead_2025) <- c("date","tr","rang_id","class","order","family","genus","species","etat")

gopro_dead_2025$date <- as.Date(gopro_dead_2025$date)
gopro_dead_2025$tr_id <- paste(format(gopro_dead_2025$date, "%Y%m%d"),
                               gopro_dead_2025$tr, "G", sep = "_")

gopro_dead_2025$method    <- "G"
gopro_dead_2025$hour      <- NA
gopro_dead_2025$condition <- NA
gopro_dead_2025$loc       <- NA
gopro_dead_2025$size      <- NA

# Recoder la classe avec les memes libelles que les obs jumelles
gopro_dead_2025$class <- factor(gopro_dead_2025$class,
                                levels = c("amphibia","aves","mammalia","reptilia","Ind"),
                                labels = c("Amphibiens","Oiseaux","Mammifères","Reptiles","Indéterminés"))

carca_all <- rbind(carca_raw_select,
                   gopro_dead_2025[, names(carca_raw_select)])


write.csv(carca_all, 
          "/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025/clean_obs_deaths_2025.csv",
          row.names = FALSE)


