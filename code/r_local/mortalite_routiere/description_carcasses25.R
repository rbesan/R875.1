# Fonction : figures descriptives pour décomptes des carcasses à pied


#install.packages("xtable")
library("xtable")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere")

# Table décomptes

all_obs_clean <- read.csv("clean_carcasses_2025.csv", header = TRUE, sep = ",")

# Table effort

effort <- read.csv("inv_road_2025_clean.csv",
                   header = TRUE,
                   sep = ",",
                   fileEncoding = "utf-8")

## Figure comparaison des méthodes

# Sous ensemble sans le drone (D) avec seulement les tronçons où G et P ont été fait

eff_GP <- subset(effort, method %in% c("P", "G"))
cle <- paste(eff_GP$tr, eff_GP$date)
complet <- tapply(eff_GP$method, cle, function(m) all(c("P", "G") %in% m))
eff_app <- eff_GP[cle %in% names(complet)[complet], ]

G_P_obs <- subset(all_obs_clean, tr_id %in% eff_app$tr_id)

lamb_group_method <- table(G_P_obs$class, G_P_obs$method)
km_P <- sum(eff_app$km[eff_app$method == "P"])
km_G <- sum(eff_app$km[eff_app$method == "G"])

tx_P <- lamb_group_method[,"P"]/km_P

tx_G <- lamb_group_method[,"G"]/km_G


tx_method <- rbind(tx_P, tx_G)

rownames(tx_method) <- c("À pied", "GoPro")

round(tx_method, 2)

png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/obs_std.png", 
    width = 8, height = 5, units = "in", res = 600)

barplot(tx_method,
        beside = TRUE,
        col = c("grey","grey30"),
        ylab = "Observations de carcasses par km parcouru",
        las =1,
        ylim = c(0,max(tx_method)*1.2),
        legend.text = row.names(tx_method),
        args.legend = list(title="Méthode", bty="n"))

dev.off()


## Figure comparaison des groupes

carcasses_GP_25 <- subset(all_obs_clean, method == "P" | method == "G")

tab_25 <- table(carcasses_GP_25$class, carcasses_GP_25$method)[,c("P","G")]

order_25 <- names(sort(rowSums(tab_25), decreasing = TRUE))

tab_GP_25 <- tab_25[order_25,]

prop_method_25 <- t(round(100*prop.table(tab_GP_25, margin=2), 1))


png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/barplot_classes.png", 
    width = 8, height = 5, units = "in", res = 600)

n_legend <- colSums(tab_GP_25)

col <- c("grey60","grey30")

bp_prop25 <- barplot(prop_method_25,
                     beside = TRUE,
        ylab = "Pourcentage des carcasses détectées")

lab_custom <- ifelse(prop_method_25 == 0,"", paste0(prop_method_25," %"))
text(x=bp_prop25, y=prop_method_25, labels=lab_custom, pos =3, xpd = TRUE)
legend("topright",
       legend = paste0(c("À pied", "GoPro"), "(n = ", n_legend[c("P","G")],")"), bty="n", fill=col)

dev.off()

## Figure boxplot par catégorie et pour chaque groupe (classe)

# liste tronçons

tr_2025 <- unique(effort[,c("tr","cat")])

# On retire les carcasses indéterminées pour la figure

obs_2025 <- subset(all_obs_clean, class!="Indéterminés")

# Résumé des observations par tronçons et classe

obs_tr_class_2025 <- table(factor(obs_2025$tr, levels = tr_2025$tr), obs_2025$class)

# On fait un dataframe avec la table

df_tr_class_2025 <- as.data.frame(obs_tr_class_2025)

names(df_tr_class_2025) <- c("tr", "class","n")

# Merge pour l'ajout de la variable sur la catégorie du tronçon

merge_cat_2025 <- merge(df_tr_class_2025, tr_2025, by= "tr")

# Boucle pour les figures dans le panneaux à 4 boxplot

groups <- levels(merge_cat_2025$class)

png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/box_cat_2025.png", 
    width = 6, height = 8, units = "in", res = 600)

par(mfrow = c(2, 2))
for (cl in groups) {
  boxplot(n~cat, data = subset(merge_cat_2025, class == cl), main = cl,
          xlab = "Catégorie de tronçons",
          ylab = "Observations de carcasses",
          col="grey92",
          las=1)
  
}
dev.off()