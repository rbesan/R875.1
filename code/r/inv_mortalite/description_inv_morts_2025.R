
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
mort25_clean2 <- mort25_clean1[mort25_clean1$Troncons_ID !=c("A10_N", "A10_S"),]
