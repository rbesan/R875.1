#!/bin/bash

#SBATCH --job-name=weather2024
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=4

in_sounds="/media/md0/MTQ-A10/AUDIOMOTHS/2024"
links="/home/robes15/Documents/R8751/output/birdnet/2024/links_weather_2024"
out_weather="/home/robes15/Documents/R8751/output/birdnet/2024/weather"
mod9="/home/robes15/Documents/birdnet_custom/mod_lise_class9.tflite"

source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew
cd /home/robes15/BirdNET-Analyzer


# On passe sur les dossiers de niveau 1 (A30) ET de niveau 2 (A10/A10_N1)
for dossier in "$in_sounds"/*/ "$in_sounds"/*/*/
do
    station=$(basename "$dossier")

    # On ignore LONGUEUIL en entier
    if [[ "$dossier" == *LONGUEUIL* ]]; then continue; fi

    # On ignore les dossiers de resultats deja produits
    if [[ "$dossier" == *outputs_anoures* ]]; then continue; fi
    if [[ "$dossier" == *segments_anoures* ]]; then continue; fi

    # On ignore les dossiers sans aucun WAV (ex: A10, qui ne contient
    # que des sous-dossiers)
    if ! ls "$dossier" 2>/dev/null | grep -qi "\.wav$"; then continue; fi

    echo "=== $station ==="

    rm -rf "$links/$station"
    mkdir -p "$links/$station" "$out_weather/$station"

    # Un lien symbolique par fichier lisible, les corrompus sont ecartes
    for wav in "$dossier"*.[wW][aA][vV]
    do
        python -c "import soundfile, sys; soundfile.info(sys.argv[1])" "$wav" 2>/dev/null \
            && ln -s "$wav" "$links/$station/"
    done

    python -m birdnet_analyzer.analyze \
        "$links/$station" \
        -o "$out_weather/$station" \
        -c "$mod9" \
        --rtype csv \
        --min_conf 0.75 \
        -t "$SLURM_CPUS_PER_TASK"
done

conda deactivate

echo "Termine."
