# Lignes de code utiles 

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
