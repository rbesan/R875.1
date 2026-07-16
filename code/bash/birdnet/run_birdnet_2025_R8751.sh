#!/bin/bash

#SBATCH --job-name=anura2025
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=4

## Données brutes
in_sounds="/media/md0/MTQ-A10/AUDIOMOTHS/2025" ## chemin pour les données brutes
## Output de birdnet
out_weather="/home/robes15/Documents/R8751/output/birdNET/2025/weather" ## csv filtre météo (mod9)
out_anura="/home/robes15/Documents/R8751/output/birdNET/2025/anura" ## csv birdnet pour les anoures (modèle de base)
## Dossier de liens
links="/home/robes15/Documents/R8751/output/birdNET/2025/links"
## Liste d'espèces
list="/home/robes15/Documents/R8751/input/species_list.txt"


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
mkdir -p "$links/$station" "$out_anura/$station"

## Boucle interne pour exclure les fichiers corrompus et faire le filtre 
for wav in "$path_station"*.[wW][aA][vV]
do
    csv="$out_weather/$station/$(basename "${wav%.*}").BirdNET.results.csv"
    if python -c "import soundfile, sys; soundfile.info(sys.argv[1])" "$wav" 2>/dev/null
    then
        grep -q ",WEATHER," "$csv" 2>/dev/null || ln -s "$wav" "$links/$station/"
    fi
done

python -m birdnet_analyzer.analyze \
"$links/$station" \
-o "$out_anura/$station" \
--rtype csv \
--min_conf 0.75 \
-t 4

done

conda deactivate

echo "Terminé."







