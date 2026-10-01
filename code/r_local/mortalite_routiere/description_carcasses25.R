## =====================================================================
## Analyse des inventaires de carcasses routières 2025
## R de base, sans dplyr
##
## Plan du script
##   1. Lecture des données
##   2. Nettoyage et harmonisation
##   3. Contrôles
##   4. Durée des inventaires par méthode
##   5. Carcasses par inventaire (par méthode et toutes méthodes)
##   6. Visites appariées à pied / GoPro
##   7. Taux de carcasses par km et figure 6
## =====================================================================

setwd("/home/robes1/CONTRAT_ULAVAL/R8751/data/clean/mortalite_routiere")


## ---------------------------------------------------------------------
## 1. Importation
## ---------------------------------------------------------------------

# Observations de carcasses
all_obs_clean <- read.csv("clean_carcasses_2025.csv", header = TRUE, sep = ",",
                          fileEncoding = "utf-8")

# Contient uniquement les transects retenus
effort <- read.csv("inv_road_2025_clean.csv", header = TRUE, sep = ",",
                   fileEncoding = "utf-8")


## ---------------------------------------------------------------------
## 2. Nettoyage et harmonisation
## ---------------------------------------------------------------------

# 2a. Retirer les espaces parasites dans les identifiants
all_obs_clean$tr_id <- trimws(all_obs_clean$tr_id)
effort$tr_id        <- trimws(effort$tr_id)

# 2b. Mêmes libellés de méthode dans les deux tables
#     (obs : P / G / D  ->  effort : À pied / GoPro / Drone)
code_meth <- c(P = "À pied", G = "GoPro", D = "Drone")
all_obs_clean$method <- unname(code_meth[all_obs_clean$method])

# 2c. Passages GoPro sans heures : vidéo analysée ou non ?
#     TRUE  = on les retire (vidéo non analysée)
#     FALSE = on les garde (vrais zéros, heures simplement non saisies)
retirer_gopro_sans_heure <- TRUE

sans_heure <- is.na(effort$hm1) | effort$hm1 == ""
gopro_sans_heure <- effort$method == "GoPro" & sans_heure
cat("Passages GoPro sans heures :", effort$tr_id[gopro_sans_heure], "\n")

if (retirer_gopro_sans_heure) {
  effort <- effort[!gopro_sans_heure, ]
}

# 2d. Garder seulement les obs rattachées à un inventaire retenu
#     (retire les transects non retenus, ex. T01_E et T20_O)
obs_TF    <- all_obs_clean$tr_id %in% effort$tr_id
obs_id_ok <- all_obs_clean[obs_TF, ]


## ---------------------------------------------------------------------
## 3. Contrôles
## ---------------------------------------------------------------------

# Chaque tr_id doit être unique dans l'effort
stopifnot(!any(duplicated(effort$tr_id)))

# Aucun code de méthode non reconnu dans les obs
stopifnot(!any(is.na(all_obs_clean$method)))

# Obs écartées et pourquoi
cat("Obs écartées (tr_id absent de l'effort) :\n")
print(all_obs_clean[!obs_TF, c("tr_id", "method", "class")])

# Nombre d'inventaires par méthode
print(table(effort$method))


## ---------------------------------------------------------------------
## 4. Durée des inventaires par méthode
## ---------------------------------------------------------------------

methodes <- c("À pied", "GoPro", "Drone")
meth_eff <- factor(effort$method, levels = methodes)

duree <- data.frame(
  moyenne    = tapply(effort$min, meth_eff, mean),
  ecart_type = tapply(effort$min, meth_eff, sd),
  min        = tapply(effort$min, meth_eff, min),
  max        = tapply(effort$min, meth_eff, max),
  n          = tapply(effort$min, meth_eff, length)
)
round(duree, 1)


## ---------------------------------------------------------------------
## 5. Carcasses par inventaire
##    On part de l'effort pour garder les inventaires sans carcasse (= 0)
## ---------------------------------------------------------------------

# Fonction : statistiques du nombre de carcasses pour une liste d'inventaires
stats_carc <- function(id_inv, obs) {
  n_carc <- table(factor(obs$tr_id, levels = id_inv))
  c(total         = sum(n_carc),
    moyenne       = mean(n_carc),
    ecart_type    = sd(n_carc),
    mediane       = median(n_carc),
    min           = min(n_carc),
    max           = max(n_carc),
    n_inventaires = length(n_carc),
    sans_carcasse = sum(n_carc == 0))
}

# 5a. Par méthode
stats_par_methode <- t(sapply(methodes, function(m) {
  stats_carc(id_inv = unique(effort$tr_id[effort$method == m]),
             obs    = obs_id_ok[obs_id_ok$method == m, ])
}))
round(stats_par_methode, 1)

# 5b. Toutes méthodes confondues
stats_toutes <- stats_carc(id_inv = unique(effort$tr_id), obs = obs_id_ok)
round(stats_toutes, 1)

# 5c. Carcasses GoPro par groupe
table(obs_id_ok$class[obs_id_ok$method == "GoPro"])


## ---------------------------------------------------------------------
## 6. Visites appariées : à pied ET GoPro le même jour, même tronçon
## ---------------------------------------------------------------------

# 6a. Passages à pied et GoPro seulement (drone retiré)
eff_GP <- subset(effort, method %in% c("À pied", "GoPro"))

# 6b. Une visite = un tronçon + une date
cle <- paste(eff_GP$tr, eff_GP$date)

# 6c. Visite complète si les deux méthodes y ont été faites
complet <- tapply(eff_GP$method, cle,
                  function(m) all(c("À pied", "GoPro") %in% m))

# 6d. Passages des visites complètes
eff_app <- eff_GP[cle %in% names(complet)[complet], ]

# 6e. Obs de ces visites
G_P_obs <- subset(obs_id_ok, tr_id %in% eff_app$tr_id)

n_visites_app <- sum(complet)
cat("Visites appariées :", n_visites_app, "\n")
table(G_P_obs$method)


## ---------------------------------------------------------------------
## 7. Taux de carcasses par km (visites appariées) et figure 6
## ---------------------------------------------------------------------

classes <- c("Amphibiens", "Indéterminés", "Mammifères", "Oiseaux", "Reptiles")

# 7a. Nombre de carcasses par groupe et par méthode
lamb_group_method <- table(factor(G_P_obs$class,  levels = classes),
                           factor(G_P_obs$method, levels = c("À pied", "GoPro")))

# 7b. Km parcourus par méthode
km_P <- sum(eff_app$km[eff_app$method == "À pied"])
km_G <- sum(eff_app$km[eff_app$method == "GoPro"])

# 7c. Taux par km
tx_P <- lamb_group_method[, "À pied"] / km_P
tx_G <- lamb_group_method[, "GoPro"]  / km_G

tx_method <- rbind(tx_P, tx_G)
rownames(tx_method) <- c("À pied", "GoPro")
round(tx_method, 2)

# Taux global par km (tous groupes)
round(c(a_pied = sum(lamb_group_method[, "À pied"]) / km_P,
        gopro  = sum(lamb_group_method[, "GoPro"])  / km_G), 2)

# 7d. Figure
png("/home/robes1/CONTRAT_ULAVAL/R8751/liv3/figs_monteregie_liv3/obs_std.png",
    width = 8, height = 7, units = "in", res = 600)

barplot(tx_method,
        beside      = TRUE,
        col         = c("grey", "grey30"),
        ylab        = "Observations de carcasses par km parcouru",
        las         = 1,
        ylim        = c(0, max(tx_method) * 1.2),
        legend.text = rownames(tx_method),
        args.legend = list(title = "Méthode", bty = "n"))

dev.off()

# 7e. Valeurs pour la légende de la figure 6
cat(sprintf("Figure 6 : %d visites appariées, %.1f km à pied, %.1f km GoPro, %d carcasses à pied, %d GoPro\n",
            n_visites_app, km_P, km_G,
            sum(lamb_group_method[, "À pied"]), sum(lamb_group_method[, "GoPro"])))