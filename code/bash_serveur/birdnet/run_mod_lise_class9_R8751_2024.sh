#!/bin/bash

#SBATCH --job-name=mod9_2024
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=4

## Données brutes
in_sounds="/media/md0/MTQ-A10/AUDIOMOTHS/2024"
## Output de birdnet
out_weather="/home/robes15/Documents/R8751/output/birdnet/2024/weather"
out_mod9="/home/robes15/Documents/R8751/output/birdnet/2024/anura_mod9"
## Dossier de liens
links="/home/robes15/Documents/R8751/output/birdnet/2024/links_mod9"
## Modèle 9
mod9="/home/robes15/Documents/birdnet_custom/mod_lise_class9.tflite"


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
    mkdir -p "$links/$station" "$out_mod9/$station"

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
        -o "$out_mod9/$station" \
        -c "$mod9" \
        --rtype csv \
        --min_conf 0.75 \
        -t "$SLURM_CPUS_PER_TASK"

done

conda deactivate

echo "Terminé."
