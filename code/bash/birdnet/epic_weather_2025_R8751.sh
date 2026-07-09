#!/bin/bash

IN_DIR="/media/md0/MTQ-A10/AUDIOMOTHS"
OUT_DIR="/home/robes15/Documents/monteregie/birdnet/2025"
MODEL="/home/robes15/Documents/monteregie/birdnet/mod_lise_class9/mod_lise_class9.tflite"

source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew

cd /home/robes15/BirdNET-Analyzer

for path_station in "$IN_DIR"/*/
do station=$(basename "$path_station")
mkdir -p "$OUT_DIR/$station"

python -m birdnet_analyzer.analyze \
    "$path_station" \
    -o "$OUT_DIR/$station" \
    -c "$MODEL" \
    --rtype csv \
    --min_conf 0.75
done

conda deactivate

echo "Terminé."
