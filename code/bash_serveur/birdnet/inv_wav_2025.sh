#!/bin/bash
#SBATCH --job-name=inv_wav2025
#SBATCH --time=05:00:00
#SBATCH --cpus-per-task=4


racine="/media/md0/MTQ-A10/AUDIOMOTHS/2025"
sortie="/home/robes15/Documents/R8751/output/birdnet/2025/csv/inventaire_wav_2025.csv"

echo "site,fichier,date,heure,taille_octets" > "$sortie"

for dossier in "$racine"/T*; do
  site=$(basename "$dossier")
  for chemin in "$dossier"/*.WAV; do
    fichier=$(basename "$chemin")
    taille=$(stat -c %s "$chemin")
    date="${fichier:0:4}-${fichier:4:2}-${fichier:6:2}"
    heure="${fichier:9:2}:${fichier:11:2}:${fichier:13:2}"
    echo "$site,$fichier,$date,$heure,$taille" >> "$sortie"
  done
done

wc -l "$sortie"
