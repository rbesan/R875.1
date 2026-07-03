#!/bin/bash
IN_DIR="/home/robes15/Documents/PROJET_A85/OUTPUT/wav_rapport2"
OUT_DIR="/home/robes15/Documents/PROJET_A85/OUTPUT/birdnet_septentrionalis_leopard_2025"
source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew
cd /home/robes15/BirdNET-Analyzer

for site_dir in "$IN_DIR"/*/; do
    site=$(basename "$site_dir")
    python -m birdnet_analyzer.segments \
        "$site_dir" \
        -r "$OUT_DIR/$site" \
        -o "$OUT_DIR/$site/segments" \
        --min_conf 0.75 \
        --seg_length 3 \
        --max_segments 99999

    find "$OUT_DIR/$site/segments" -name "*.wav" | while read -r clip; do
        filename=$(basename "$clip")
        dir=$(dirname "$clip")
        # BirdNET génère : {conf}_{rank}_{date}_{heure}_{debut}s_{fin}s.wav
        conf=$(echo "$filename"  | cut -d'_' -f1)
        rank=$(echo "$filename"  | cut -d'_' -f2)
        date=$(echo "$filename"  | cut -d'_' -f3)
        heure=$(echo "$filename" | cut -d'_' -f4)
        reste=$(echo "$filename" | cut -d'_' -f5-)
        # Renommer en : {date}_{heure}_{debut}s_{fin}s_{conf}_{rank}_{site}.wav
        mv "$clip" "$dir/${date}_${heure}_${reste%.wav}_${conf}_${rank}_${site}.wav"
    done
done

conda deactivate
echo "Terminé."
