#!/bin/bash

IN_DIR="/home/robes15/Documents/PROJET_A85/OUTPUT/wav_rapport2"
OUT_DIR="/home/robes15/Documents/PROJET_A85/OUTPUT/birdnet_septentrionalis_leopard_2025"
MODEL="/home/robes15/Documents/PROJET_A85/mod_lise_class9/mod_lise_class9.tflite"

source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew

find "$IN_DIR" -name "*.WAV" | while read -r wav; do
    site=$(basename $(dirname "$wav"))
    mkdir -p "$OUT_DIR/$site"
    mkdir -p "$OUT_DIR/$site/clips"
    cd /home/robes15/BirdNET-Analyzer

    python -m birdnet_analyzer.analyze \
        "$wav" \
        -o "$OUT_DIR/$site" \
        -c "$MODEL" \
        --rtype csv \
        --min_conf 0.75 \
        --threads 4

done

conda deactivate
echo "Terminé."
