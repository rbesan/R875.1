#!/bin/bash

#SBATCH --job-name=weather2025
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=4

## Données brutes
in_sounds="/media/md0/MTQ-A10/AUDIOMOTHS/2025" ## chemin pour les données brutes
## Dossier de liens
links="/home/robes15/Documents/R8751/output/birdnet/2025/links"
## Output de birdnet
out_weather="/home/robes15/Documents/R8751/output/birdnet/2025/weather" ## chemin de dépôt des csv pour la première analyse
## Modèle personnalisé
mod9="/home/robes15/Documents/birdnet_custom/mod_lise_class9.tflite" ## chemin pour le modèle entrainé




## Utilisation de conda
source /opt/conda/etc/profile.d/conda.sh # activation de conda
conda activate birdnetNew # création d'un environnement pour birdnet

## Utilisation de BirdNET
cd /home/robes15/BirdNET-Analyzer # définir le répertoir de travail où se trouve le logiciel birdnet


## Boucle birdnet
for path_station in "$in_sounds"/*/ ## on fait travailler la boucle sur chaque sous-dossier (chaque station)
do station=$(basename "$path_station") ## On extrait le nom de chaque station pour créer ensuite un sous-dossier et y mettre tables dans out_weather
if [ "$station" = "LONGUEUIL" ]; then  ## Le dossier LONGUEUIL est ignoré pour cette analyse car il y a un niveau de sous-dossier supplémentaire et je ne sais pas le gérer simplement dans ces boucles.
continue
fi
rm -rf "$links/$station"
mkdir -p "$links/$station" "$out_weather/$station" ## Création du sous-dossier dans out_weather pour chaque station afin de classer les output du filtre

## Boucle interne pour exclure les fichiers corrompus
for wav in "$path_station"*.[wW][aA][vV]
do
python -c "import soundfile, sys; soundfile.info(sys.argv[1])" "$wav" 2>/dev/null \
            && ln -s "$wav" "$links/$station/"
done

## Lancement du modèle BirdNET entrainé
python -m birdnet_analyzer.analyze \
    "$links/$station" \
    -o "$out_weather/$station" \
    -c "$mod9" \
    --rtype csv \
    --min_conf 0.75 \
    -t "$SLURM_CPUS_PER_TASK" ## forcer pour le respect du nombre de coeurs
done

conda deactivate

echo "Terminé."


