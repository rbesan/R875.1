#!/bin/bash
#SBATCH --job-name=clips_mod9_2024
#SBATCH --time=05:00:00
#SBATCH --cpus-per-task=4

## Données brutes
in_sounds="/media/md0/MTQ-A10/AUDIOMOTHS/2024"
## csv issus du script mod9
in_csv="/home/robes15/Documents/R8751/output/birdnet/2024/anura_mod9"
## Sortie des clips
out_clips="/home/robes15/Documents/R8751/output/birdnet/2024/clips_anura_mod9"

source /opt/conda/etc/profile.d/conda.sh
conda activate birdnetNew
cd /home/robes15/BirdNET-Analyzer

## On boucle sur les stations qui ont des CSV
for csv in "$in_csv"/*/; do
    station=$(basename "$csv")

    ## Retrouver le dossier des WAV : soit au 1er niveau (A30),
    ## soit au 2e niveau (A10/A10_N1)
    dossier_wav="$in_sounds/$station"
    if [ ! -d "$dossier_wav" ]; then
        for d in "$in_sounds"/*/"$station"; do
            if [ -d "$d" ]; then dossier_wav="$d"; fi
        done
    fi

    if [ ! -d "$dossier_wav" ]; then
        echo "Dossier audio introuvable pour $station, station ignoree."
        continue
    fi

    echo "=== $station  ($dossier_wav) ==="

    python -m birdnet_analyzer.segments \
        "$dossier_wav" \
        -r "$in_csv/$station" \
        -o "$out_clips/$station" \
        --min_conf 0.75 \
        --seg_length 3 \
        --max_segments 99999 \
        -t "$SLURM_CPUS_PER_TASK"

    find "$out_clips/$station" -name "*.wav" | while read -r clip; do
        filename=$(basename "$clip")
        dir=$(dirname "$clip")
        # BirdNET genere : {conf}_{rank}_{nom du fichier d'origine}_{debut}s_{fin}s.wav
        # En 2024 le nom d'origine contient deja le site : A10_N1_20240507_000000
        conf=$(echo "$filename"  | cut -d'_' -f1)
        rank=$(echo "$filename"  | cut -d'_' -f2)
        reste=$(echo "$filename" | cut -d'_' -f3-)
        # Renomme en : {site}_{date}_{heure}_{debut}s_{fin}s_{conf}_{rank}.wav
        mv "$clip" "$dir/${reste%.wav}_${conf}_${rank}.wav"
    done
done

conda deactivate
echo "Termine."
