#!/bin/bash
#SBATCH --job-name=inv_wav2023
#SBATCH --time=05:00:00
#SBATCH --cpus-per-task=4

racine="/media/md0/MTQ-A10/AUDIOMOTHS/2023"
sortie="/home/robes15/Documents/R8751/output/birdnet/2023/csv_2023/inventaire_wav_2023.csv"

mkdir -p "$(dirname "$sortie")"

echo "site,fichier,date,heure,taille_octets" > "$sortie"

for dossier in "$racine"/AM*; do
  site=$(basename "$dossier")
  for chemin in "$dossier"/*.WAV; do
    [ -e "$chemin" ] || continue
    fichier=$(basename "$chemin")
    taille=$(stat -c %s "$chemin")
    date="${fichier:0:4}-${fichier:4:2}-${fichier:6:2}"
    heure="${fichier:9:2}:${fichier:11:2}:${fichier:13:2}"
    echo "$site,$fichier,$date,$heure,$taille" >> "$sortie"
  done
done

wc -l "$sortie"
