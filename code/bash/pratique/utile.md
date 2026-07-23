# Lignes de code utiles 

# Connexion serveur labo

ssh -X robes15@132.203.41.191


## Voir arborescence complète de dossiers/ fichiers : 

tree -L 

On peut ajouter un nombre de strates 

ex : tree -L 2

## Emplacement audiomoths pour MTQ-A10 : 

/media/md0/MTQ-A10/AUDIOMOTHS


## Code pour afficher un nombre de fichiers (pratique quand nombre trop important)

for d in */; do
  echo "${d%/}"
  ls "$d" | head -n 15 | sed 's/^/    /'
  n=$(ls "$d" | wc -l)
  [ "$n" -gt 15 ] && echo "    ... et $((n -15)) autres"
done

## Pour faire rouler les scripts
## 1 - se mettre sur le dossier local
## 2 - copier coller script
##scp fichier utilisateur@adresseIP:/chemin/destination
## EXEMPLE POUR MON SERVEUR : scp epic_weather_2025_R8751.sh robes15@132.203.41.191:/home/robes15/Documents/test
## 3 - aller sur le serveur
## 4 - lancer la commande
##sbatch test.bash
## 5 - output (exemple)
##less slurm-364.out

# copier coller vers le serveur
scp csv_check_mod9_2025.R  robes15@132.203.41.191:/home/robes15/Documents/R8751/code/r/birdnet 

# copier coller depuis le serveur vers le local
scp validation_mod9.csv robes1@10.244.50.22:/home/robes1/CONTRAT_ULAVAL/R8751/output/csv_validation_birdnet


