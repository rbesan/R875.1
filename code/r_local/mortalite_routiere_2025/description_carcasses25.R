# Fonction : figures descriptives pour décomptes des carcasses à pied


#install.packages("xtable")
library("xtable")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025")

carca_clean <- read.csv("clean_bino_2025.csv", header = TRUE, sep = ",")

sum(table(carca_clean$Espece))

table_classe <- table(carca_clean$Classe)

pute <- table(carca_clean$Site)

mean(pute)
sd(pute)


percent <- round(100*prop.table(table_classe),1)

barplot_classes <- barplot(table_classe,
                          ylim = c(0,max(table_classe)*1.2),
                          ylab="Nombre de carcasses",
                          las = 1)
text(barplot_classes, table_classe, labels = paste0(percent, " %"), pos =  3, xpd = TRUE)


carca_clean$Date <- as.Date(carca_clean$Date, format = "%d/%m/%Y")
carca_clean$mois <- factor(format(carca_clean$Date, "%m"),
                                levels = c("05","06","07","08"),
                                labels = c("Mai","Juin","Juillet","Août"))

barplot(table(carca_clean$Classe, carca_clean$mois),
        ylab = "Nombre de carcasses", legend.text = levels(carca_clean$Classe),
        args.legend = list(x = "topleft", bty = "n"))


length(carca_clean$Espece)
table_site <- table(carca_clean$Site)
order_site <- sort(table_site)



barplot(order_site, horiz = TRUE,las =1, xlab = "Nombre de carcasses")
