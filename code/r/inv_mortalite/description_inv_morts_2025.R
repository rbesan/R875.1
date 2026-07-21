#install.packages("xtable")
library("xtable")

# Objectif : analyse descriptive des inventaires de mortalité

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw")

mort25 <- read.csv("inv_mort_2025.csv", 
         header = TRUE,
         sep = ";",
         fileEncoding = "Latin1")

# retrait des colonnes qui ne servent à rien

mort25_clean1 <- mort25[, !(names(mort25)) %in% c("commentaire", 
                       "Temp_air",
                       "Couv_nuage",
                       "Vent",
                       "Initiales",
                       "Nom_fichier",
                       "Vitesse",
                       "Commentaires",
                       "X",
                       "Passage_num...pour.le.drone.seulement..ID.du.passage.faunique.prévue.de.1.à.4",
                       "X.1",
                       "X.2",
                       "X.3",
                       "X.4",
                       "X.5",
                       "X.6",
                       "X.7",
                       "X.8",
                       "X.9",
                       "X.10",
                       "X.11",
                       "X.12",
                       "X.13")]

# On enlève les 3 lignes d'exemple
mort25_clean2 <- mort25_clean1[!(mort25_clean1$Troncons_ID %in% c("A10_N", "A10_S")), ]
mort25_clean3 <- mort25_clean2[mort25_clean2$Date_inv != "", ]


# Converstion format numérique et dates
mort25_clean3$Obs <- as.numeric(mort25_clean3$Obs)
mort25_clean3$date <- as.Date(mort25_clean3$Date_inv, format = "%d/%m/%Y")


# Suppression du premier inventaire GoPro sur 41 et 42
mort25_clean4 <- subset(mort25_clean3, !(Troncons_ID %in% c(41, 42) & Date_inv == "03/06/2025"))

visites <- tapply(mort25_clean4$date, mort25_clean4$Troncons_ID, function(x) length(unique(x)))
n_method <- tapply(mort25_clean4$Technique, mort25_clean4$Troncons_ID, length)
type_method <- tapply(mort25_clean4$Technique, 
                      mort25_clean4$Troncons_ID, 
                      function(x) paste(sort(unique(x)), 
                                        collapse = "+"))
table_inv <- data.frame(
  troncon_id = names(visites),
  visites = as.integer(visites),
  type_method = type_method)

table_inv <- table_inv[order(as.numeric(table_inv$troncon_id), decreasing = FALSE),]

