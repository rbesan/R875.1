#!/bin/bash
#SBATCH --job-name=inv_wav2024
#SBATCH --time=05:00:00
#SBATCH --cpus-per-task=1

racine="/media/md0/MTQ-A10/AUDIOMOTHS/2024"
sortie="/home/robes15/Documents/R8751/output/birdnet/2024/csv_2024/inventaire_wav_2024.csv"

echo "secteur,site,fichier,date,heure,taille_octets" > "$sortie"

find "$racine" \
  \( -path "$racine/LONGUEUIL" -o -type d -name 'outputs*' -o -type d -name 'segments*' \) -prune \
  -o -type f -iname '*.wav' -printf '%P\t%s\n' \
| sort \
| awk -F'\t' 'BEGIN{OFS=","}
  {
    n = split($1, p, "/")
    f = p[n]
    secteur = p[1]
    site = (n >= 3) ? p[n-1] : p[1]

    b = f
    sub(/\.[^.]*$/, "", b)
    if (b !~ /[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9]$/) {
      print "Nom non conforme : " $1 > "/dev/stderr"
      next
    }
    ts = substr(b, length(b) - 14)
    date  = substr(ts,1,4) "-" substr(ts,5,2) "-" substr(ts,7,2)
    heure = substr(ts,10,2) ":" substr(ts,12,2) ":" substr(ts,14,2)
    print secteur, site, f, date, heure, $2
  }' >> "$sortie"

wc -l "$sortie"
