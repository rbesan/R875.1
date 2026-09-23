#!/bin/bash

#SBATCH --job-name=mod9_2023
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=4

## Données brutes
in_sounds="/media/md0/MTQ-A10/AUDIOMOTHS/2023" ## chemin pour les données brutes
## Input pour le filtre
in_weather="/home/robes15/Documents/R8751/output/birdnet/2023/csv_weather_2023" ## csv filtre météo (mod9)
## Output de birdnet
out_mod9="/home/robes15/Documents/R8751/output/birdnet/2023/anura_mod9_2023" ## csv birdnet avec les anoures non reconnus par le modèle de base
## Dossier de liens
links="/home/robes15/Documents/R8751/output/birdnet/2023/links_weather_2023"
## Modèle 9
mod9="/home/robes15/Documents/birdnet_custom/mod_lise_class9.tflite"


## Lancement de conda
source /opt/conda/etc/profile.d/conda.sh # activation de conda
conda activate birdnetNew # création d'un environnement pour birdnet

# Définir le répertoir de travail où se trouve le logiciel birdnet
cd /home/robes15/BirdNET-Analyzer

## Boucle birdnet
for path_station in "$in_sounds"/*/ # On utilise le nom des fichiers comme sur le serveur
do station=$(basename "$path_station")
if [ "$station" = "LONGUEUIL" ]; then
continue
fi
rm -rf "$links/$station"
mkdir -p "$links/$station" "$out_mod9/$station"

## Boucle interne pour exclure les fichiers corrompus et faire le filtre sur les détections de WEATHER
for wav in "$path_station"*.[wW][aA][vV]
do
    csv="$in_weather/$station/$(basename "${wav%.*}").BirdNET.results.csv"
    if python -c "import soundfile, sys; soundfile.info(sys.argv[1])" "$wav" 2>/dev/null
    then
        grep -q ",WEATHER," "$csv" 2>/dev/null || ln -s "$wav" "$links/$station/"
    fi
done

python -m birdnet_analyzer.analyze \
"$links/$station" \
-o "$out_mod9/$station" \
-c "$mod9" \
--rtype csv \
--min_conf 0.75 \
-t "$SLURM_CPUS_PER_TASK"

done

conda deactivate

echo "Terminé."
