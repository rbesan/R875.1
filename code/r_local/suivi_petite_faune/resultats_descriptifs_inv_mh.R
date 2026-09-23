
library(xtable)

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune_2025")



inv_mh_25_rw <- read.csv("inv_mh_2025.csv", header = TRUE, sep = ";")
df_sites25 <- data.frame(MILIEU.HUMIDE = unique(inv_mh_25_rw$MILIEU.HUMIDE))

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
                                  labels = c("A. americanus", 
                                             "Anura ind.", 
                                             "Poisson", 
                                             "B. lentiginosus", 
                                             "A. alba", 
                                             "A. herodias",
                                             "C. picta",
                                             "C. serpentina",
                                             "H. versicolor",
                                             "Ecrevisse",
                                             "L. clamitans",
                                             "L. pipiens",
                                             "L. sylvaticus",
                                             "O. virginianus",
                                             "T. sirtalis",
                                             "Testudines ind.", 
                                             "Amphibia indet."))



inv_mh_25_amphibiens <- droplevels(subset(inv_mh_25_select, ESPECE %in% c(
  "H. versicolor", "L. clamitans", "L. pipiens",
  "L. sylvaticus", "A. americanus", "Anura ind.")))
inv_mh_25_amphibiens$NOMBRE <- as.numeric(inv_mh_25_amphibiens$NOMBRE)

amphibiens_sansNA1 <- inv_mh_25_amphibiens[!is.na(inv_mh_25_amphibiens$NOMBRE), ]
amphibiens_sansNA2 <- amphibiens_sansNA1[amphibiens_sansNA1$NOMBRE > 0, ]

amphibiens_sansNA2$STADE <- factor(amphibiens_sansNA2$STADE,
                                   levels = c("tetard", "adulte", "métamorphe", "oeuf", "juvénile"),
                                   labels = c("Larve", "Adulte", "Métamorphe", "Oeufs", "Juvénile"))

amphibiens_sansNA2$STADE <- substr(amphibiens_sansNA2$STADE, 1, 2)

resume_stade_amph <- tapply(amphibiens_sansNA2$STADE,
                            list(amphibiens_sansNA2$MILIEU.HUMIDE, amphibiens_sansNA2$ESPECE),
                            function(x) paste(sort(unique(x)), collapse = "/"))

resume_df_amph <- data.frame(MILIEU.HUMIDE = rownames(resume_stade_amph),
                             resume_stade_amph, check.names = FALSE)

resume_amph_complet <- merge(df_sites25, resume_df_amph,
                             by = "MILIEU.HUMIDE", all.x = TRUE)
resume_amph_complet[is.na(resume_amph_complet)] <- "--"
names(resume_amph_complet)[names(resume_amph_complet) == "MILIEU.HUMIDE"] <- "Site"

print(xtable(resume_amph_complet), booktabs = TRUE, comment = FALSE,
      include.rownames = FALSE)

#### Tableau reptiles

inv_mh_25_squamates <- droplevels(subset(inv_mh_25_select, ESPECE %in% c(
  "C. picta", "C. serpentina", "Testudines ind.",
  "T. sirtalis")))



inv_mh_25_squamates$NOMBRE <- as.numeric(inv_mh_25_squamates$NOMBRE)




squamates_sansNA1 <- inv_mh_25_squamates[!is.na(inv_mh_25_squamates$NOMBRE), ]
squamates_sansNA2 <- squamates_sansNA1[squamates_sansNA1$NOMBRE > 0, ]

squamates_sansNA2$STADE <- factor(squamates_sansNA2$STADE, levels = "adulte",
                                   labels ="Adulte")


squamates_sansNA2$STADE <- substr(squamates_sansNA2$STADE, 1, 2)

resume_stade <- tapply(squamates_sansNA2$STADE,
                       list(squamates_sansNA2$MILIEU.HUMIDE, squamates_sansNA2$ESPECE),
                       function(x) paste(sort(unique(x)), collapse = "/"))

resume_df <- data.frame(MILIEU.HUMIDE = rownames(resume_stade),
                        resume_stade, check.names = FALSE)

resume_complet <- merge(df_sites25, resume_df, by = "MILIEU.HUMIDE", all.x = TRUE)
resume_complet[is.na(resume_complet)] <- "--"

names(resume_complet)[names(resume_complet)=="MILIEU.HUMIDE"] <- "Site"

print(xtable(resume_complet), booktabs = TRUE, comment = FALSE,include.rownames = FALSE)

#### Tableau autres

inv_mh_25_autres <- droplevels(subset(inv_mh_25_select, ESPECE %in% c(
  "B. lentiginosus", "A. alba", "A. herodias",
  "Poisson", "Ecrevisse", "O. virginianus")))
inv_mh_25_autres$NOMBRE <- as.numeric(inv_mh_25_autres$NOMBRE)

autres_sansNA1 <- inv_mh_25_autres[!is.na(inv_mh_25_autres$NOMBRE), ]
autres_sansNA2 <- autres_sansNA1[autres_sansNA1$NOMBRE > 0, ]


resume_autres <- tapply(autres_sansNA2$ESPECE,
                            list(autres_sansNA2$MILIEU.HUMIDE),
                            function(x) paste(sort(unique(as.character(x))), collapse = "/"))

resume_df_autres <- data.frame(MILIEU.HUMIDE = rownames(resume_autres),
                             resume_autres, check.names = FALSE)

resume_autres_complet <- merge(df_sites25, resume_df_autres,
                             by = "MILIEU.HUMIDE", all.x = TRUE)

resume_autres_complet[is.na(resume_autres_complet)] <- "--"
names(resume_autres_complet) <- c("Site", "Autres taxons observés")


print(xtable(resume_autres_complet), include.rownames = FALSE, booktabs = TRUE, comment = FALSE)


