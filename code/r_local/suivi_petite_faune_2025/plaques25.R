#install.packages("xtable")
library("xtable")


# Objectif : analyse descriptive des inventaires de mortalité

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune_2025")

reptile25_brut25 <- read.csv("plaques_2025.csv", 
                            header = TRUE, 
                            sep = ",", 
                            na.strings = c("", "-", " ", "NA", "N/A"))

reptile25_clean <- reptile25_brut25[, !names(reptile25_brut25) %in% c("Visite_num",
                                                                      "Couv_nuage",
                                                                      "Commentaires",
                                                                      "X",
                                                                      "X.1",
                                                                      "X.2",
                                                                      "X.3")]

reptile25_clean$Presence <- ifelse(reptile25_clean$Presence >= 1, 1,0)

length(unique(reptile25_clean$Troncon_ID))

reptile25_clean$Date_inv <- as.Date(reptile25_clean$Date_inv, format = "%d/%m/%Y")

reptile25_clean$Heure_debut <- hms::as_hms(paste0(reptile25_clean$Heure_debut, ":00"))
reptile25_clean$Heure_fin <- hms::as_hms(paste0(reptile25_clean$Heure_fin, ":00"))

reptile25_clean$Troncon_ID <- factor(reptile25_clean$Troncon_ID,
                                     levels = sort(unique(reptile25_clean$Troncon_ID)), 
                                     labels = paste0("T", sort(unique(reptile25_clean$Troncon_ID))))

reptile25_clean$Position <- factor(reptile25_clean$Position, levels = c("sous_planche",
                                                                        "sous_geotextile",
                                                                        "sur_geotextile",
                                                                        "a_proximite"), 
                                   labels = c("Sous la planche","Sous géotextile","Sur géotextile","À proximité"))

thsi <- subset(reptile25_clean, Especes=="THSI")

mat_thsi <- xtabs(Presence ~ Position + Troncon_ID, data = thsi)

sum_thsi <- colSums(mat_thsi)

png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/suivi_petite_faune_2025/plaques25.png", 
    width = 8, height = 5, units = "in", res = 600)

bar_thsi <- barplot(mat_thsi,
        col= grey.colors(nrow(mat_thsi)),
        xlab = "Tronçons",
        ylab = "Nombre de détection de T. Sirtalis",
        ylim = c(0,10),
        cex.names = 0.7,
        legend.text = rownames(mat_thsi),
        args.legend = list(x="topright",bty = "n", cex = 0.7))

text(bar_thsi, sum_thsi,
     labels = ifelse(sum_thsi == 0, "", sum_thsi), pos = 3, cex = 0.7)

dev.off()
