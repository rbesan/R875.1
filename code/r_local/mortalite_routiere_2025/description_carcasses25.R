#install.packages("xtable")
library("xtable")


# Objectif : analyse descriptive des inventaires de mortalité

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/raw")

carca_raw <- read.csv("bino_carcasses.csv", header =  TRUE, sep = ",")

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


table_classe <- table(carca_raw_select$Classe)

percent <- round(100*prop.table(table_classe),1)

barplot_classes <- barplot(table_classe,
                          ylim = c(0,max(table_classe)*1.2),
                          ylab="Nombre de carcasses",
                          las = 1)
text(barplot_classes, table_classe, labels = paste0(percent, " %"), pos =  3, xpd = TRUE)


carca_raw_select$Date <- as.Date(carca_raw_select$Date, format = "%d/%m/%Y")
carca_raw_select$mois <- factor(format(carca_raw_select$Date, "%m"),
                                levels = c("05","06","07","08"),
                                labels = c("Mai","Juin","Juillet","Août"))

barplot(table(carca_raw_select$Classe, carca_raw_select$mois),
        ylab = "Nombre de carcasses", legend.text = levels(carca_raw_select$Classe),
        args.legend = list(x = "topleft", bty = "n"))


table_site <- table(carca_raw_select$Site)
order_site <- sort(table_site)

barplot(order_site, horiz = TRUE,las =1, xlab = "Nombre de carcasses")
