#install.packages("xtable")
library("xtable")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere")


effort <- read.csv("inv_road_2025_clean.csv",
         header = TRUE,
         sep = ",",
         fileEncoding = "utf-8")

nb_method <- tapply(effort$method, effort$tr, function(x) length(unique(x)))
effort <- effort[effort$tr %in% names(nb_method)[nb_method > 1], ]


effort$method <- factor(effort$method, 
       levels = c("À pied","Drone","GoPro"),
       labels = c("À pied","Drone","GoPro"))

length(unique(effort$tr_id))


effort$type <- factor(effort$type, 
                        levels = c("Autoroute","Secondaire étroite","Secondaire séparée"),
                        labels = c("Autoroute","Secondaire étroite","Secondaire séparée"))


section <- sort(unique(effort$tr))

data.inv <- data.frame()

for (s in section) {
  lignes <- effort[effort$tr == s,]
  data.inv <- rbind(data.inv,
                    data.frame(
                      Section = s,
                      Type = lignes$type[1],
                      Catégorie = lignes$cat[1],
                      Visites = length(unique(lignes$date)),
                      Methodes = paste(sort(unique(lignes$method)), collapse = "+")
                    ))
}

data.inv

print(xtable(data.inv,
             caption = "Nombre de visites et méthodes utilisées pour les inventaires de carcasses, par tronçon.",
             label   = "tab:visites"),
      include.rownames    = FALSE,
      booktabs            = TRUE,
      tabular.environment = "longtable",
      floating            = FALSE,
      caption.placement   = "top",
      size                = "small")


png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/effort_carcasses_2025.png",
    width = 16.5, height = 12, units = "cm", res = 600, pointsize = 10)

par(mar = c(4, 4.5, 1, 1), las = 1)

boxplot(min ~ method, data = effort, outline = FALSE, log = "y",
        xlab = "Méthode", ylab = "Temps par visite (min)",
        yaxt = "n")
axis(2, at = c(1, 2, 5, 10, 20, 50, 100))
points(jitter(as.numeric(effort$method), amount = 0.12),
       effort$min, pch = 16, col = rgb(0, 0, 0, 0.5))

dev.off()


## ---------------------------------------------------------------------
## Carcasses par tronçon selon la catégorie de tronçon
## ---------------------------------------------------------------------

obs <- read.csv("clean_carcasses_2025.csv", header = TRUE, sep = ",",
                fileEncoding = "utf-8")

# Harmoniser les identifiants et garder les obs des inventaires retenus
obs$tr_id    <- trimws(obs$tr_id)
effort$tr_id <- trimws(effort$tr_id)
obs <- obs[obs$tr_id %in% effort$tr_id, ]

# Rattacher chaque obs à son tronçon
obs$tr <- effort$tr[match(obs$tr_id, effort$tr_id)]

classes4 <- c("Amphibiens", "Mammifères", "Oiseaux", "Reptiles")
troncons <- sort(unique(effort$tr))

# Un tronçon = une seule catégorie
stopifnot(all(tapply(effort$cat, effort$tr, function(x) length(unique(x))) == 1))
cat_tr <- tapply(effort$cat, effort$tr, function(x) x[1])[troncons]

# Nombre de carcasses par tronçon et par groupe (0 inclus)
n_tr <- table(factor(obs$tr,    levels = troncons),
              factor(obs$class, levels = classes4))

png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/box_cat_2025.png",
    width = 16.5, height = 15, units = "cm", res = 600, pointsize = 10)

par(mfrow = c(2, 2), mar = c(4, 4.5, 2, 1), las = 1)

for (cl in classes4) {
  y <- as.vector(n_tr[, cl])
  boxplot(y ~ factor(cat_tr), col = "grey92",
          main = cl,
          xlab = "Catégorie de tronçons",
          ylab = "Nombre de carcasses")
}

dev.off()

