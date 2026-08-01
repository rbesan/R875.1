###################################################################
# Script R rapport 3 R875.1
# Auteur : Robin Besançon
# Objectif : exploration des données d'audiomoths pour 2025
###################################################################

library("xtable")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/output/csv_validation_birdnet")

inv_wav25 <- read.csv("inventaire_wav_2025.csv")

bilan_wav <- data.frame(
  site=levels(factor(inv_wav25$site)),
  first=as.Date(tapply(inv_wav25$date, inv_wav25$site,min), origin="1970-01-01"),
  last=as.Date(tapply(inv_wav25$date, inv_wav25$site, max), origin="1970-01-01"),
  n_wav= tapply(inv_wav25$fichier, inv_wav25$site, length),
  n_jour=tapply(inv_wav25$date, inv_wav25$site, function (x) length(unique(x))),
  n_bug= tapply(inv_wav25$taille_octets, inv_wav25$site, function(x) sum(x < 17280488))
  
)

bilan_wav$first <- format(bilan_wav$first, "%Y-%m-%d")

bilan_wav$last <- format(bilan_wav$last,  "%Y-%m-%d")

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
                                     labels = c("P. maculata","H. versicolor", "P. crucifer", "L. palustris", "L. sylvaticus", "L. clamitans",
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

resume_detect <- aggregate(val ~ species + site + date + time, 
                           data = table_birdnet_2025, 
                           FUN = function(x) as.integer(sum(x > 0)))

select_resume_detect <- resume_detect[resume_detect$val > 0,]

table_detect <- table(select_resume_detect$species, select_resume_detect$site)

data_detect <- as.data.frame.matrix(t(table_detect))

data_detect$site <- row.names(data_detect)


data_detect[] <- lapply(data_detect, function(x) ifelse(x==0, "-",as.character(x)))

data_detect <- data_detect[c("site",setdiff(names(data_detect),"site"))]

data_detect <- data_detect[,!names(data_detect) %in% c("L. sylvaticus",
                                                       "L. palustris",
                                                       "L. catesbeianus",
                                                       "L. septentrionalis")]


print(xtable(data_detect), booktabs = TRUE, include.rownames = FALSE)






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


pheno <- unique(table_birdnet_2025[table_birdnet_2025$val == 1, c("site", "date", "time", "species")])
pheno$date <- as.Date(pheno$date)

#pheno <- pheno[pheno$date >= as.Date("2025-04-01") & pheno$date <= as.Date("2025-09-30"), ]

levels(pheno$species)

# Figure de densité de probabilité
couleurs <- c(
  "P. crucifer"   = "#D55E00",  # vermillon
  "L. sylvaticus" = "#E69F00",  # orange
  "L. clamitans"  = "#009E73",  # vert bleuté
  "A. americanus" = "#0072B2",  # bleu
  "H. versicolor" = "#CC79A7",  # violet rosé
  "P. maculata"   = "#56B4E9"   # bleu ciel
)

ggplot(pheno, aes(x = date, fill = species, color = species)) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = couleurs) +
  scale_color_manual(values = couleurs) +
  scale_x_date(
    date_labels = "%B",
    date_breaks = "1 month",
    limits = c(as.Date("2025-04-01"), as.Date("2025-09-30"))
  ) +
  labs(x = NULL, y = expression("Densité de probabilité (jour"^{-1}*")"),
       title = "Distribution temporelle de l'activité de chant des anoures détectés en 2025",
       fill = NULL, color = NULL) +
  theme_minimal(base_size = 11) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.text = element_text(face = "italic"),
    panel.grid = element_blank(),
    panel.grid.major.x = element_line(color = "black",
                                      linewidth = 0.3,
                                      linetype = "dashed")
  )
