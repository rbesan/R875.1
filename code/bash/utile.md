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
