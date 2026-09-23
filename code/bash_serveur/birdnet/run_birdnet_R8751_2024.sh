#!/bin/bash

#SBATCH --job-name=anura2024
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=4

## Données brutes
in_sounds="/media/md0/MTQ-A10/AUDIOMOTHS/2024"
## Output de birdnet
out_anura="/home/robes15/Documents/R8751/output/birdnet/2024/anura"
## Input weather
in_weather="/home/robes15/Documents/R8751/output/birdnet/2024/weather"
## Dossier de liens
links="/home/robes15/Documents/R8751/output/birdnet/2024/links_anura2024"
## input liste d'espèces
list="/home/robes15/Documents/R8751/input/species_list.txt"


## Lancement de conda
source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew

# Définir le répertoir de travail où se trouve le logiciel birdnet
cd /home/robes15/BirdNET-Analyzer


## Boucle birdnet
## On passe sur les dossiers de niveau 1 (A30) ET de niveau 2 (A10/A10_N1)
for path_station in "$in_sounds"/*/ "$in_sounds"/*/*/
do
    station=$(basename "$path_station")

    # On ignore LONGUEUIL en entier
    if [[ "$path_station" == *LONGUEUIL* ]]; then continue; fi

    # On ignore les dossiers de resultats deja produits
    if [[ "$path_station" == *outputs_anoures* ]]; then continue; fi
    if [[ "$path_station" == *segments_anoures* ]]; then continue; fi

    # On ignore les dossiers sans aucun WAV (ex: A10, qui ne contient
    # que des sous-dossiers)
    if ! ls "$path_station" 2>/dev/null | grep -qi "\.wav$"; then continue; fi

    echo "=== $station ==="

    rm -rf "$links/$station"
    mkdir -p "$links/$station" "$out_anura/$station"

    ## Boucle interne pour exclure les fichiers corrompus et faire le filtre
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
        -o "$out_anura/$station" \
        --rtype csv \
        --min_conf 0.75 \
        --slist "$list" \
        -t "$SLURM_CPUS_PER_TASK"

done

conda deactivate

echo "Terminé."
