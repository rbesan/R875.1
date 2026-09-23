###################################################################
# Script R rapport 3 R875.1
# Auteur : Robin Besançon
# Objectif : exploration des données d'audiomoths pour 2025
###################################################################

library("xtable")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/suivi_petite_faune")


############################################################################
### 2025

inv_wav25 <- read.csv("inventaire_wav_2025.csv")

bilan_wav_2025 <- data.frame(
  site=levels(factor(inv_wav25$site)),
  first=as.Date(tapply(inv_wav25$date, inv_wav25$site,min), origin="1970-01-01"),
  last=as.Date(tapply(inv_wav25$date, inv_wav25$site, max), origin="1970-01-01"),
  n_wav= tapply(inv_wav25$fichier, inv_wav25$site, length),
  n_jour=tapply(inv_wav25$date, inv_wav25$site, function (x) length(unique(x))),
  n_bug= tapply(inv_wav25$taille_octets, inv_wav25$site, function(x) sum(x < 17280488))
  
)

bilan_wav_2025$first <- format(bilan_wav$first, "%Y-%m-%d")

bilan_wav_2025$last <- format(bilan_wav$last,  "%Y-%m-%d")

#print(xtable(bilan_wav, align = "llccrrr",
#      caption = "Effort d'enregistrement par site, saison 2025."),
#include.rownames = FALSE, booktabs = TRUE,
#caption.placement = "top")


table_birdnet_2025 <- rbind(
  read.csv("validation_birdnet_2025.csv"),
  read.csv("validation_mod9_2025.csv"))

# Renommage des espèces
table_birdnet_2025$species <- factor(table_birdnet_2025$species,
                                     levels = c("Striped Chorus Frog","Gray Treefrog","Spring Peeper", "Pickerel Frog", "Wood Frog", "Green Frog",
                                                "American Toad", "American Bullfrog", "PIPIENS", "SEPTENTRIONALIS"),
                                     labels = c("P. maculata","D. versicolor", "P. crucifer", "L. palustris", "L. sylvaticus", "L. clamitans",
                                                "A. americanus", "L. catesbeianus", "L. pipiens", "L. septentrionalis"))


table_birdnet_2025$site <- factor(table_birdnet_2025$site, levels = c("T01", 
                                                                      "T20",
                                                                      "T41_N1",
                                                                      "T42_N2",
                                                                      "T42_N3",
                                                                      "T42_S2",
                                                                      "T42_S3",
                                                                      "T47_1",
                                                                      "T47_2",
                                                                      "T47_3",
                                                                      "T48",
                                                                      "T49_1",
                                                                      "T49_2",
                                                                      "T52",
                                                                      "T57",
                                                                      "T65"))

resume_detect_2025 <- aggregate(val ~ species + site + date + time, 
                           data = table_birdnet_2025, 
                           FUN = function(x) as.integer(sum(x > 0)))

select_resume_detect_2025 <- resume_detect_2025[resume_detect_2025$val > 0,]

table_detect_2025 <- table(select_resume_detect_2025$species, select_resume_detect_2025$site)

data_detect_2025 <- as.data.frame.matrix(t(table_detect_2025))

data_detect_2025$site <- row.names(data_detect_2025)


data_detect_2025[] <- lapply(data_detect_2025, function(x) ifelse(x==0, "-",as.character(x)))

data_detect_2025 <- data_detect_2025[c("site",setdiff(names(data_detect_2025),"site"))]

data_detect_2025 <- data_detect_2025[,!names(data_detect_2025) %in% c("L. sylvaticus",
                                                       "L. palustris",
                                                       "L. catesbeianus",
                                                       "L. septentrionalis")]


print(xtable(data_detect_2025), booktabs = TRUE, include.rownames = FALSE)






tab_dataframe_birdnet_2025 <- as.data.frame(xtabs(val~site+species, data = table_birdnet_2025))




barplot1 <- tapply(tab_dataframe_birdnet_2025$Freq, tab_dataframe_birdnet_2025$species, sum)

barplot2 <- data.frame(species = names(barplot1),
                       clips = as.vector(barplot1))

barplot3 <- barplot2[order(barplot2$clips), ]

par(mar = c(4.5, 8, 1, 2))

occ_clips <- barplot(barplot3$clips, names.arg = barplot3$species, horiz = TRUE, las = 1,
                     col = "grey90", border = "grey40",
                     xlim = c(0,max(barplot3$clips) * 1.1),
                     xlab = "Nombre de clips (3s) extraient par espèce puis validés en 2025")

text(barplot3$clips, occ_clips, labels = ifelse(barplot3$clips == 0, "", barplot3$clips), pos = 4, cex = 1, )


# Figure de densité de probabilité

# On sélectionne les déctions par fichier pour chaque espèce
pheno25 <- unique(table_birdnet_2025[table_birdnet_2025$val==1, c("site","date","time","species")])
levels(pheno25$species)
# Conversion en date
pheno25$date <- as.Date(pheno25$date)

png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/suivi_petite_faune_2025/pheno_25.png", 
    width = 8, height = 5, units = "in", res = 600)

# Panneau pour les graphiques
par(mfrow = c(5,1), mar = c(0.5, 4, 0.5, 8), oma = c(5, 0, 1, 0))
# Spécifier les bornes inf et sup des dates au format numérique
xlim <- as.numeric(as.Date(c("2025-04-01","2025-09-01")))
# objet à appeler à la fin pour spécifier les étiquettes en abscisse
xnames <- seq(as.Date("2025-04-01"), as.Date("2025-09-01"), by = "month")

# Courbe P. maculata
maculata <- density(as.numeric(pheno25$date[pheno25$species=="P. maculata"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(maculata$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(maculata,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(maculata$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("P. maculata",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe H. versicolor
versi <- density(as.numeric(pheno25$date[pheno25$species=="D. versicolor"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(versi$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(versi,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(versi$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("H. versicolor",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe P. crucifer
cruci <- density(as.numeric(pheno25$date[pheno25$species=="P. crucifer"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(cruci$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(cruci,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(cruci$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("P. crucifer",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe L. clamitans
clami <- density(as.numeric(pheno25$date[pheno25$species=="L. clamitans"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(clami$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(clami,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(clami$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("L. clamitans",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe A. americanus
america <- density(as.numeric(pheno25$date[pheno25$species=="A. americanus"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(america$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(america,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(america$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("A. americanus",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

axis(1, as.numeric(xnames), format(xnames, "%B"), las = 2)

mtext(expression("Densité de probabilité (Jour"^{-1}*")"), side=2, outer = TRUE, line=-2)


dev.off()


##################################################################################################
##################################################################################################
############################ SUIVI 2024 ##########################################################
##################################################################################################
##################################################################################################


inv_wav24 <- read.csv("inventaire_wav_2024.csv")

bilan_wav_2024 <- data.frame(
  site=levels(factor(inv_wav24$site)),
  first=as.Date(tapply(inv_wav24$date, inv_wav24$site,min), origin="1970-01-01"),
  last=as.Date(tapply(inv_wav24$date, inv_wav24$site, max), origin="1970-01-01"),
  n_wav= tapply(inv_wav24$fichier, inv_wav24$site, length),
  n_jour=tapply(inv_wav24$date, inv_wav24$site, function (x) length(unique(x))),
  n_bug= tapply(inv_wav24$taille_octets, inv_wav24$site, function(x) sum(x < 17280488))
  
)

bilan_wav_2024$first <- format(bilan_wav_2024$first, "%Y-%m-%d")

bilan_wav_2024$last <- format(bilan_wav_2024$last,  "%Y-%m-%d")

print(xtable(bilan_wav_2024, align = "llccrrr",
      caption = "Effort d'enregistrement par site, saison 2025."),
include.rownames = FALSE, booktabs = TRUE,
caption.placement = "top")


table_birdnet_2024 <- rbind(
  read.csv("validation_birdnet_2024.csv"),
  read.csv("validation_mod9_2024.csv"))

# Renommage des espèces
table_birdnet_2024$species <- factor(table_birdnet_2024$species,
                                     levels = c("Striped Chorus Frog","Gray Treefrog","Spring Peeper", "Pickerel Frog", "Wood Frog", "Green Frog",
                                                "American Toad", "American Bullfrog", "PIPIENS", "SEPTENTRIONALIS"),
                                     labels = c("P. triseriata","D. versicolor", "P. crucifer", "L. palustris", "L. sylvaticus", "L. clamitans",
                                                "A. americanus", "L. catesbeianus", "L. pipiens", "L. septentrionalis"))

resume_detect_2024 <- aggregate(val ~ species + site + date + time, 
                           data = table_birdnet_2024, 
                           FUN = function(x) as.integer(sum(x > 0)))

select_resume_detect_2024 <- resume_detect_2024[resume_detect_2024$val > 0,]

table_detect_2024 <- table(select_resume_detect_2024$species, select_resume_detect_2024$site)

data_detect_2024 <- as.data.frame.matrix(t(table_detect_2024))

data_detect_2024$site <- row.names(data_detect_2024)


data_detect_2024[] <- lapply(data_detect_2024, function(x) ifelse(x==0, "-",as.character(x)))

data_detect_2024 <- data_detect_2024[c("site",setdiff(names(data_detect_2024),"site"))]

data_detect_2024 <- data_detect_2024[,!names(data_detect_2024) %in% c("L. sylvaticus",
                                                       "L. palustris",
                                                       "L. catesbeianus",
                                                       "L. septentrionalis")]


print(xtable(data_detect_2024), booktabs = TRUE, include.rownames = FALSE)






tab_dataframe_birdnet_2024 <- as.data.frame(xtabs(val~site+species, data = table_birdnet_2024))




bar1_2024 <- tapply(tab_dataframe_birdnet_2024$Freq, tab_dataframe_birdnet_2024$species, sum)

bar2_2024 <- data.frame(species = names(bar1_2024),
                       clips = as.vector(bar1_2024))

bar3_2024 <- bar2_2024[order(bar2_2024$clips), ]

png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/clips_24.png", 
    width = 8, height = 5, units = "in", res = 600)

par(mar = c(4.5, 8, 1, 2))

occ_clips <- barplot(bar3_2024$clips, names.arg = bar3_2024$species, horiz = TRUE, las = 1,
        col = "grey90", border = "grey40",
        xlim = c(0,max(bar3_2024$clips) * 1.1),
        xlab = "Nombre de clips (3s) extraient par espèce puis validés en 2024")

text(bar3_2024$clips, 
     occ_clips, 
     labels = ifelse(bar3_2024$clips == 0, 
                     "", 
                     bar3_2024$clips), 
     pos = 4, 
     cex = 1)
dev.off()

# Figure de densité de probabilité

# On sélectionne les déctions par fichier pour chaque espèce
pheno24 <- unique(table_birdnet_2024[table_birdnet_2024$val==1, c("site","date","time","species")])
levels(pheno24$species)
# Conversion en date
pheno24$date <- as.Date(pheno24$date)

png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/pheno_24.png", 
    width = 8, height = 5, units = "in", res = 600)

# Panneau pour les graphiques
par(mfrow = c(4,1), mar = c(0.5, 4, 0.5, 8), oma = c(5, 3, 1, 0))
# Spécifier les bornes inf et sup des dates au format numérique
xlim <- as.numeric(as.Date(c("2024-03-01","2024-09-01")))
# objet à appeler à la fin pour spécifier les étiquettes en abscisse
xnames <- seq(as.Date("2024-03-01"), as.Date("2024-09-01"), by = "month")


# Courbe H. versicolor
versi <- density(as.numeric(pheno24$date[pheno24$species=="D. versicolor"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(versi$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(versi,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(versi$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("D. versicolor",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe P. crucifer
cruci <- density(as.numeric(pheno24$date[pheno24$species=="P. crucifer"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(cruci$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(cruci,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(cruci$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("P. crucifer",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe L. clamitans
clami <- density(as.numeric(pheno24$date[pheno24$species=="L. clamitans"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(clami$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(clami,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(clami$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("L. clamitans",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe A. americanus
america <- density(as.numeric(pheno24$date[pheno24$species=="A. americanus"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(america$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(america,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(america$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("A. americanus",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

axis(1, as.numeric(xnames), format(xnames, "%B"), las = 2)

mtext(expression("Densité de probabilité (Jour"^{-1}*")"), side=2, outer = TRUE, line=1)


dev.off()



##################################################################################################
##################################################################################################
############################ SUIVI 2023 ##########################################################
##################################################################################################
##################################################################################################


## Tableau pour l'effort d'enregistrement de 2023


inv_wav23 <- read.csv("inventaire_wav_2023.csv")

bilan_wav_2023 <- data.frame(
  site=levels(factor(inv_wav23$site)),
  first=as.Date(tapply(inv_wav23$date, inv_wav23$site,min), origin="1970-01-01"),
  last=as.Date(tapply(inv_wav23$date, inv_wav23$site, max), origin="1970-01-01"),
  n_wav= tapply(inv_wav23$fichier, inv_wav23$site, length),
  n_jour=tapply(inv_wav23$date, inv_wav23$site, function (x) length(unique(x))),
  n_bug= tapply(inv_wav23$taille_octets, inv_wav23$site, function(x) sum(x < 17280488))
  
)

bilan_wav_2023$first <- format(bilan_wav_2023$first, "%Y-%m-%d")

bilan_wav_2023$last <- format(bilan_wav_2023$last,  "%Y-%m-%d")

print(xtable(bilan_wav_2023, align = "llccrrr",
             caption = "Effort d'enregistrement par site, saison 2023."),
      include.rownames = FALSE, booktabs = TRUE,
      caption.placement = "top")

## Tableau des détections de 2023


table_birdnet_2023 <- rbind(
  read.csv("validation_birdnet_2023.csv"),
  read.csv("validation_mod9_2023.csv"))

table_birdnet_2023$species <- factor(table_birdnet_2023$species,
                                     levels = c("Striped Chorus Frog","Gray Treefrog","Spring Peeper", "Pickerel Frog", "Wood Frog", "Green Frog",
                                                "American Toad", "American Bullfrog", "PIPIENS", "SEPTENTRIONALIS"),
                                     labels = c("P. maculata","D. versicolor", "P. crucifer", "L. palustris", "L. sylvaticus", "L. clamitans",
                                                "A. americanus", "L. catesbeianus", "L. pipiens", "L. septentrionalis"))



resume_detect_2023 <- aggregate(val ~ species + site + date + time, 
                                data = table_birdnet_2023, 
                                FUN = function(x) as.integer(sum(x > 0)))

select_resume_detect_2023 <- resume_detect_2023[resume_detect_2023$val > 0,]

table_detect_2023 <- table(select_resume_detect_2023$species, select_resume_detect_2023$site)

data_detect_2023 <- as.data.frame.matrix(t(table_detect_2023))

data_detect_2023$site <- row.names(data_detect_2023)


data_detect_2023[] <- lapply(data_detect_2023, function(x) ifelse(x==0, "-",as.character(x)))

data_detect_2023 <- data_detect_2023[c("site",setdiff(names(data_detect_2023),"site"))]



data_detect_2023 <- data_detect_2023[,!names(data_detect_2023) %in% c("L. palustris",
                                                                      "L. catesbeianus",
                                                                      "L. septentrionalis")]


print(xtable(data_detect_2023), booktabs = TRUE, include.rownames = FALSE)

## Figure pour la phénologie 2023



tab_dataframe_birdnet_2023 <- as.data.frame(xtabs(val~site+species, data = table_birdnet_2023))




bar1_2023 <- tapply(tab_dataframe_birdnet_2023$Freq, tab_dataframe_birdnet_2023$species, sum)

bar2_2023 <- data.frame(species = names(bar1_2023),
                        clips = as.vector(bar1_2023))

bar3_2023 <- bar2_2023[order(bar2_2023$clips), ]

png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/clips_23.png", 
    width = 8, height = 5, units = "in", res = 600)

par(mar = c(4.5, 8, 1, 2))

occ_clips <- barplot(bar3_2023$clips, names.arg = bar3_2023$species, horiz = TRUE, las = 1,
                     col = "grey90", border = "grey40",
                     xlim = c(0,max(bar3_2023$clips) * 1.1),
                     xlab = "Nombre de clips (3s) extraient par espèce puis validés en 2023")

text(bar3_2023$clips, 
     occ_clips, 
     labels = ifelse(bar3_2023$clips == 0, 
                     "", 
                     bar3_2023$clips), 
     pos = 4, 
     cex = 1)
dev.off()

# Figure de densité de probabilité

# On sélectionne les déctions par fichier pour chaque espèce
pheno23 <- unique(table_birdnet_2023[table_birdnet_2023$val==1, c("site","date","time","species")])
levels(pheno23$species)
# Conversion en date
pheno23$date <- as.Date(pheno23$date)

png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/pheno_23.png", 
    width = 8, height = 5, units = "in", res = 600)

# Panneau pour les graphiques
par(mfrow = c(4,1), mar = c(0.5, 4, 0.5, 8), oma = c(5, 3, 1, 0))
# Spécifier les bornes inf et sup des dates au format numérique
xlim <- as.numeric(as.Date(c("2023-03-01","2023-09-01")))
# objet à appeler à la fin pour spécifier les étiquettes en abscisse
xnames <- seq(as.Date("2023-03-01"), as.Date("2023-09-01"), by = "month")

# Courbe L. sylvaticus
versi <- density(as.numeric(pheno23$date[pheno23$species=="L. sylvaticus"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(versi$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(versi,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(versi$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("D. versicolor",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)


# Courbe H. versicolor
versi <- density(as.numeric(pheno23$date[pheno23$species=="D. versicolor"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(versi$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(versi,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(versi$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("D. versicolor",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe P. crucifer
cruci <- density(as.numeric(pheno23$date[pheno23$species=="P. crucifer"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(cruci$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(cruci,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(cruci$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("P. crucifer",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe L. clamitans
clami <- density(as.numeric(pheno23$date[pheno23$species=="L. clamitans"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(clami$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(clami,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(clami$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("L. clamitans",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

# Courbe A. americanus
america <- density(as.numeric(pheno23$date[pheno23$species=="A. americanus"]))
plot(NA, 
     xlim = xlim, 
     ylim=c(0, max(america$y)*1.1),
     xaxt = "n",
     yaxt ="n",
     xlab="", 
     ylab="",
     yaxs = "i")
polygon(america,
        col = "grey45",
        border = "black",
        lwd=1)
axis(2, pretty(c(0, max(america$y)), 3), 
     cex.axis = 0.7, 
     las = 1)
mtext("A. americanus",
      side = 4,
      las = 1, 
      line = 0.5, 
      font = 3, 
      cex = 0.7)

axis(1, as.numeric(xnames), format(xnames, "%B"), las = 2)

mtext(expression("Densité de probabilité (Jour"^{-1}*")"), side=2, outer = TRUE, line=1)


dev.off()


