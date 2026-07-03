#!/bin/bash

#VENV="/home/robes1/.venv/BIRDNET/bin/activate"

IN_DIR="/media/md0/MTQ-A10/AUDIOMOTHS"
OUT_DIR="/home/robes15/Documents/monteregie/birdnet/2025"
MODEL="/home/robes15/Documents/monteregie/birdnet/mod_lise_class9/mod_lise_class9.tflite"

source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew

find "$IN_DIR" -name "*.WAV" | while read -r wav; do
    site=$(basename $(dirname "$wav"))
    mkdir -p "$OUT_DIR/$site"
    
cd /home/robes15/BirdNET-Analyzer
python -m birdnet_analyzer.analyze \
    "$wav" \
    -o "$OUT_DIR/$site" \
    -c "$MODEL" \
    --rtype csv \
    --min_conf 0.75
done

deactivate

echo "Terminé."
