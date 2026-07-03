#!/bin/bash
IN_DIR="/home/robes15/Documents/PROJET_A85/OUTPUT/wav_rapport2"
OUT_DIR="/home/robes15/Documents/PROJET_A85/OUTPUT/birdnet_anoures_2025"
LIST="/home/robes15/Documents/PROJET_A85/DOCS/species_list/species_list.txt"

source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew

find "$IN_DIR" -name "*.WAV" | while read -r wav; do
    site=$(basename $(dirname "$wav"))
    mkdir -p "$OUT_DIR/$site"
    cd /home/robes15/BirdNET-Analyzer
    python -m birdnet_analyzer.analyze \
        "$wav" \
        -o "$OUT_DIR/$site" \
        --rtype csv \
        --min_conf 0.75 \
        --threads 4 \
        --slist "$LIST"
done

conda deactivate
echo "Terminé."
