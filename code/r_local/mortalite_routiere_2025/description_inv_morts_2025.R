#install.packages("xtable")
library("xtable")

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025")


effort <- read.csv("inv_road_2025_clean.csv",
         header = TRUE,
         sep = ",",
         fileEncoding = "utf-8")

effort$method <- factor(effort$method, 
       levels = c("P","D","G"),
       labels = c("À pied","Drone","GoPro"))





section <- sort(unique(effort$tr))

data.inv <- data.frame()

for (s in section) {
  lignes <- effort[effort$tr == s,]
  data.inv <- rbind(data.inv,
                    data.frame(
                      Section = s,
                      Tronçon = lignes$tr_glob[1],
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
    width = 7, height = 9, units = "in", res = 800)

boxplot(min~method, 
        data=effort,
        outline=FALSE,
        xlab = "Méthode",
        ylab = "Effort par visite (min)")

points(jitter(as.numeric(effort$method), amount = 0.12),
       effort$min, pch = 16, col = rgb(0, 0, 0, 0.5))
dev.off()


