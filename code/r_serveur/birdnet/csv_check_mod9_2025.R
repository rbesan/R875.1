##################################################################################
# Script R rapport 3 R875.1
# Auteur : Robin Besançon
# Objectif : CSV pour vérifier les clips de g. du nord et de g. léopard
#####################################################################################

path <- "/home/robes15/Documents/R8751/output/birdnet/2025/clips_anura_mod9"
species <- c("SEPTENTRIONALIS", "PIPIENS")

rel  <- list.files(path, pattern = "\\.wav$", recursive = TRUE)
part <- strsplit(rel, "/")
site <- sapply(part, `[`, 1)
esp  <- toupper(sapply(part, `[`, 2))
f    <- basename(rel)

keep <- esp %in% species
site <- site[keep]; esp <- esp[keep]; f <- f[keep]
stopifnot(length(f) > 0)

rest <- substring(f, nchar(site) + 2)
num  <- function(i) as.numeric(sub(
  "^[0-9]{8}_[0-9]{6}_([0-9.]+)s_([0-9.]+)s_([0-9.]+)_([0-9]+)\\.wav$",
  paste0("\\", i), rest))

annot <- data.frame(
  site    = site,
  date    = as.Date(substr(rest, 1, 8), "%Y%m%d"),
  time    = substr(rest, 10, 15),
  species = esp,
  start   = num(1),
  end     = num(2),
  conf    = num(3),
  clip    = f,
  val     = NA_integer_
)
annot <- annot[order(annot$date, annot$time, annot$site, annot$start, annot$species), ]

cat("Clips total :", nrow(annot), "\n")
print(table(annot$site, annot$species))
print(summary(annot$conf))

out <- file.path(path, "validation_mod9.csv")
write.csv(annot, out, row.names = FALSE)
cat("Écrit :", out, "\n")