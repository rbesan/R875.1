##################################################################################
# Script R rapport 3 R875.1
# Auteur : Robin Besançon
# Objectif : CSV pour vérifier les clips de g. du nord et de g. léopard
#####################################################################################

path_mod9_2025 <- "/home/robes15/Documents/R8751/output/birdNET/2025/clips_anura_mod9"
species <- c("SEPTENTRIONALIS",
             "PIPIENS")

wav <- list.files(path_mod9_2025, pattern = "\\.wav$", recursive = TRUE, full.names = TRUE)

annot <- do.call(rbind, lapply(species, function(esp) {
  f <- basename(wav[grepl(paste0("/", esp, "/"), wav)])
  if (length(f) == 0) return(NULL)
  data.frame(
    site    = sub("^.+_([^_]+)\\.wav$",                         "\\1", f),
    date    = as.Date(sub("^([0-9]{8})_.+$",                    "\\1", f), "%Y%m%d"),
    time    = sub("^[0-9]{8}_([0-9]{6})_.+$",                   "\\1", f),
    species = esp,
    start   = as.numeric(sub("^[0-9]{8}_[0-9]{6}_([0-9.]+)s_.+$", "\\1", f)),
    clip    = f,
    val     = NA_integer_,
    stringsAsFactors = FALSE
  )
}))

annot <- annot[order(annot$site, annot$date, annot$time, annot$start, annot$species), ]
cat("Clips total :", nrow(annot), "\n")

print(table(annot$site, annot$species))

write.csv(annot,
          file      = file.path(path_mod9_2025, "validation_mod9.csv"),
       row.names = FALSE
)
cat("Écrit :", file.path(path_mod9_2025, "validation_mod9.csv"), "\n")