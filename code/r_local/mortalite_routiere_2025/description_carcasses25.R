# Fonction : figures descriptives pour décomptes des carcasses à pied


#install.packages("xtable")
library("xtable")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025")

# Table des conditions 

carca_clean <- read.csv("clean_bino_2025.csv", header = TRUE, sep = ",")

# Table des conditions de transects
effort <- read.csv("clean_road_2025.csv",
                   header = TRUE,
                   sep = ",",
                   fileEncoding = "utf-8")



# Table des catégories 

cat_tr <- read.csv("clean_tr_cat.csv",
                   header = TRUE,
                   sep = ",",
                   fileEncoding = "utf-8")

carca_clean$visit <- paste(carca_clean$tr, carca_clean$Date, "Pied", sep="_")
inventaires <- table(carca_clean$visit)

effort$obs <- as.integer(inventaires[effort$visit])

effort$obs[is.na(effort$obs)] <- 0

pied25 <- effort[effort$protocol=="Pied",]

mean(pied25$obs)
sd(pied25$obs)
sum(pied25$obs)

table_classe <- table(carca_clean$Classe)



percent <- round(100*prop.table(table_classe),1)

barplot_classes <- barplot(table_classe,
                          ylim = c(0,max(table_classe)*1.2),
                          ylab="Nombre de carcasses",
                          las = 1)
text(barplot_classes, table_classe, labels = paste0(percent, " %"), pos =  3, xpd = TRUE)


carca_clean$Date <- as.Date(carca_clean$Date)
carca_clean$mois <- factor(format(carca_clean$Date, "%m"),
                                levels = c("06","07","08"),
                                labels = c("Juin","Juillet","Août"))


cols <- gray(c(0.9, 0.7, 0.45, 0.2))

png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/mortalite_routiere_2025/barplot_period.png", 
    width = 7, height = 8, units = "in", res = 600)
barplot(table(carca_clean$Classe, carca_clean$mois),
        ylab = "Nombre de carcasses", legend.text = levels(carca_clean$Classe),
        args.legend = list(x = "topleft", bty = "n"))
legend("topleft",
       legend = c("Oiseaux", 
                  "Mammifères", 
                  "Anoures",
                  "Reptiles"),
       fill = cols,
       bty = "n")
dev.off()
# Figure du nombre cumulé d'observations de carcasses par tronçons lors des inventaires à pied (2025)

# Table du nombre de carcasses par tronçon

obs_pied <- aggregate(obs~tr, data=pied25, FUN =sum)

# On ajoute les colonnes ensembles

obs_cat <- merge(obs_pied, cat_tr, by="tr", all.x = TRUE)

# Tri du plus petit au plus grand 

obs_cat <- obs_cat [order(obs_cat$obs),]

obs_cat$couleur <- ifelse(obs_cat$cat == 0, "grey85",
                          ifelse(obs_cat$cat==1, "grey60", "grey40"))


png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/mortalite_routiere_2025/sites_carcasses.png", 
    width = 7, height = 8, units = "in", res = 600)


barplot(obs_cat$obs, 
        names.arg = obs_cat$tr,
        horiz = TRUE,
        las =1, 
        xlab = "Nombre de carcasses",
        col=obs_cat$couleur)
legend("bottomright",
       legend = c("Catégorie 0", "Catégorie 1", "Catégorie 2"),
       fill = c("grey80", "grey50", "grey40"),
       bty = "n")
dev.off()

table_cat <- table(carca_clean$cat)

barplot(table_cat,las =1, xlab = "Nombre de carcasses")


nb_tr <- table(carca_clean$tr)
cat_tr <- carca_clean$cat[match(names(nb_tr), carca_clean$tr)]


png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/mortalite_routiere_2025/box_cat_2025.png", 
    width = 8, height = 6, units = "in", res = 600)

boxplot(nb_tr ~ cat_tr,
        xlab = "Catégorie de tronçons",
        ylab = "Observations de carcasses",
        boxwex = 0.45,
        staplewex = 0,
        whisklty = 1,
        col = "grey93",
        border = "grey35",
        las = 1)

dev.off()
