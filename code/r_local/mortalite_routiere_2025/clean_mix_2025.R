
setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere_2025")

gopro_2025 <- read.csv("clean_gopro_2025.csv",
                           header = TRUE,
                           sep = ",",
                           fileEncoding = "utf-8")

gopro_2025_select <- gopro_2025[,!names(gopro_2025) %in% c("cat",
                                                        "taxon_id")]


pied_2025 <- read.csv("clean_bino_2025.csv",
                      header = TRUE,
                      sep = ",",
                      fileEncoding = "utf-8")

pied_2025$obs <- 1
sum_pied_2025 <- aggregate(obs~tr+group, data = pied_2025, FUN = sum)
sum_pied_2025$method <- "pied"

gopro_2025_select$group[which(gopro_2025_select$group == "mammalia")] <- "Mammifères"
gopro_det <- subset(gopro_2025_select, obs > 0, select = c("tr","group","obs","method"))
comp <- rbind(gopro_det[, c("group","obs","method")],
              sum_pied_2025[, c("group","obs","method")])
tot <- aggregate(obs ~ group + method, data = comp, FUN = sum)
tot <- merge(expand.grid(group = sort(unique(comp$group)),
                         method = c("gopro","pied"), stringsAsFactors = FALSE),
             tot, by = c("group","method"), all.x = TRUE)
tot$obs[is.na(tot$obs)] <- 0

tab_bar <- xtabs(obs ~ method + group, data = tot)


png("/home/robes1/CONTRAT_ULAVAL/R8751/output/graphique/resultats/mortalite_routiere_2025/mix_2025.png", 
    width = 7, height = 8, units = "in", res = 600)


barplot(tab_bar, beside = TRUE, ylim = c(0, max(tab_bar) * 1.15),
              ylab = "Nombre d'observations de carcasses")
legend("topright",
       legend = c("À pied", "GoPro"),
       fill = c("grey80", "grey40"),
       bty = "n")
dev.off()



