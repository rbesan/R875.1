#install.packages("xtable")
library("xtable")


# Objectif : analyse descriptive des inventaires de mortalité

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw/suivi_petite_faune")

reptile25_brut25 <- read.csv("plaques_2025.csv", 
                            header = TRUE, 
                            sep = ",")

reptile25_clean <- reptile25_brut25[, !names(reptile25_brut25) %in% c("visite_num",
                                                                      "couv_nuag",
                                                                      "commentaires",
                                                                      "X",
                                                                      "X.1",
                                                                      "X.2",
                                                                      "X.3")]


reptile25_clean$date <- as.Date(reptile25_clean$date)

reptile25_clean$troncon <- factor(reptile25_clean$troncon,
                                     levels = sort(unique(reptile25_clean$troncon)))

reptile25_clean$position <- factor(reptile25_clean$position, levels = c("sous_planche",
                                                                        "sous_geotextile",
                                                                        "sur_geotextile",
                                                                        "a_proximite"), 
                                   labels = c("Sous la planche","Sous géotextile","Sur géotextile","À proximité"))

thsi <- subset(reptile25_clean, especes=="thamnophis_sirtalis")

mat_thsi <- xtabs(abondance ~ position + troncon, data = thsi)

sum_thsi <- colSums(mat_thsi)

png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/plaques25.png", 
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
