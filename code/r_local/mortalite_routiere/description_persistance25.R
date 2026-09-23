
setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025")

library(lme4)

persi_2025 <- read.csv("clean_persistance_2025.csv", header = TRUE, sep = ",")

length(unique(persi_2025$tr))
nrow(persi_2025)

table(persi_2025$tr)

# Figure pour le moment de la prédation

persi_2025$moment <- factor(ifelse(as.integer(substr(persi_2025$heure1, 1, 2)) < 12, "matin", "soir"))

length(unique(persi_2025$tr))

mod_persi25 <- glmer(conso ~ moment + (1 | tr), family = binomial, data = persi_2025)

X <- model.matrix(~ moment, data.frame(moment = factor(c("matin", "soir"))))
fit <- as.vector(X %*% fixef(mod_persi25))
se <- sqrt(diag(X %*% as.matrix(vcov(mod_persi25)) %*% t(X)))

est <- plogis(fit)
inf <- plogis(fit - 1.96 * se)
sup <- plogis(fit + 1.96 * se)

png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/mortalite_routiere_2025/periode_persi_2025.png", 
    width = 8, height = 6, units = "in", res = 600)


plot(1:2, est, ylim = c(0, 0.6), xlim = c(0.5, 2.5), xaxt = "n",
     xlab = "Moment du déploiement", ylab = "Probabilité de prédation")
axis(1, at = 1:2, labels = c("matin", "soir"))
arrows(1:2, inf, 1:2, sup, angle = 90, code = 3, length = 0.05)

dev.off()

# Figure predateurs

png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/mortalite_routiere_2025/pred_persi_2025.png", 
    width = 8, height = 6, units = "in", res = 600)

pred_id <- table(persi_2025$id_pred)

bar_pred_id_2025 <- barplot(pred_id,
        ylim = c(0,10), 
        ylab =  "Nombre de prédations",
        names.arg = c("C. brachyrhynchos","C. corax", "F. catus", "Indéterminé"))

text(x = bar_pred_id_2025, y = pred_id, labels = pred_id, pos = 3)
dev.off()

# Figure heure de prédation

persi_2025$tranche <- as.integer(substr(persi_2025$heure_pred,1,2))


pred_tranche <- table(persi_2025$conso, factor(persi_2025$tranche, levels = 0:23))

png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/mortalite_routiere_2025/tranches_persi_2025.png", 
width = 8, height = 6, units = "in", res = 600)

barplot(pred_tranche, space = 0,
        yaxt="n",
        xlab = "Tranche horaire",
        ylab = "Nombre de prédations")
axis(2, at=0:max(pred_tranche))
dev.off()

