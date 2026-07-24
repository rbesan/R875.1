#!/bin/bash
#SBATCH --job-name=clips_mod9_2025
#SBATCH --time=08:00:00
#SBATCH --cpus-per-task=4

## Données brutes
in_sounds="/media/md0/MTQ-A10/AUDIOMOTHS/2025"
## csv issus du script run_mod_lise_class9_R8751_2025.sh
in_csv="/home/robes15/Documents/R8751/output/birdnet/2025/anura"
## Sortie des clips
out_clips="/home/robes15/Documents/R8751/output/birdnet/2025/clips_anura"

source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew
cd /home/robes15/BirdNET-Analyzer

## On boucle sur les stations qui ont des CSV
for csv in "$in_csv"/*/; do
    station=$(basename "$csv")

    python -m birdnet_analyzer.segments \
        "$in_sounds/$station" \
        -r "$in_csv/$station" \
        -o "$out_clips/$station" \
        --min_conf 0.75 \
        --seg_length 3 \
        --max_segments 99999 \
        -t "$SLURM_CPUS_PER_TASK"

    find "$out_clips/$station" -name "*.wav" | while read -r clip; do
        filename=$(basename "$clip")
        dir=$(dirname "$clip")
        # BirdNET genere : {conf}_{rank}_{date}_{heure}_{debut}s_{fin}s.wav
        conf=$(echo "$filename"  | cut -d'_' -f1)
        rank=$(echo "$filename"  | cut -d'_' -f2)
        date=$(echo "$filename"  | cut -d'_' -f3)
        heure=$(echo "$filename" | cut -d'_' -f4)
        reste=$(echo "$filename" | cut -d'_' -f5-)
        # Renomme en : {date}_{heure}_{debut}s_{fin}s_{conf}_{rank}_{site}.wav
        mv "$clip" "$dir/${station}_${date}_${heure}_${reste%.wav}_${conf}_${rank}.wav"
    done
done

conda deactivate
echo "Termine."
