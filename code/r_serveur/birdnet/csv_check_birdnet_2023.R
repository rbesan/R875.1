##################################################################################
# Script R rapport 3 R875.1
# Auteur : Robin Besancon
# Objectif : CSV pour verifier les clips d'especes identifiees par birdnet en 2023
#####################################################################################

path <- "/home/robes15/Documents/R8751/output/birdnet/2023/clips_anura_2023"

species <- c(
  "American Toad", "Gray Treefrog", "Spring Peeper", "Striped Chorus Frog",
  "Green Frog", "Pickerel Frog", "American Bullfrog", "Wood Frog"
)

rel <- list.files(path, pattern = "\\.wav$", recursive = TRUE, ignore.case = TRUE)
stopifnot(length(rel) > 0)

part <- strsplit(rel, "/")
site <- sapply(part, `[`, 1)
esp  <- sapply(part, `[`, 2)
f    <- basename(rel)

keep <- esp %in% species
site <- site[keep]; esp <- esp[keep]; f <- f[keep]
stopifnot(length(f) > 0)

# Les noms de clips ne portent pas de prefixe de site : on retire un eventuel
# prefixe du type "AM1_" seulement s'il est present, sans jamais couper a
# l'aveugle un nombre fixe de caracteres.
rest <- sub("^[A-Za-z]+[0-9]*_(?=[0-9]{8}_[0-9]{6}_)", "", f, perl = TRUE)

pat <- "^([0-9]{8})_([0-9]{6})_([0-9.]+)s_([0-9.]+)s_([0-9.]+)_([0-9]+)\\.wav$"

bad <- !grepl(pat, rest, ignore.case = TRUE)
if (any(bad)) {
  cat("Noms de fichiers non reconnus :", sum(bad), "\n")
  print(utils::head(rest[bad], 10))
}

grp <- function(i) sub(pat, paste0("\\", i), rest, ignore.case = TRUE)

annot <- data.frame(
  site    = site,
  date    = as.Date(grp(1), "%Y%m%d"),
  time    = grp(2),
  species = esp,
  start   = as.numeric(grp(3)),
  end     = as.numeric(grp(4)),
  conf    = as.numeric(grp(5)),
  clip    = f,
  val     = NA_integer_,
  stringsAsFactors = FALSE
)

annot <- annot[order(annot$date, annot$time, annot$site, annot$start, annot$species), ]

cat("Clips total :", nrow(annot), "\n")
print(table(annot$site, annot$species))
print(summary(annot$conf))
cat("NA dans date :", sum(is.na(annot$date)), "\n")
cat("NA dans conf :", sum(is.na(annot$conf)), "\n")

out <- file.path(path, "validation_birdnet_2023.csv")
write.csv(annot, out, row.names = FALSE)
cat("Ecrit :", out, "\n")