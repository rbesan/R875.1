# Projet R875.1, 2024-2027





---

## Organisation des fichiers
```
R875.1/
├── archives
├── code
│   ├── bash
│   └── r
├── contracts
├── data
│   ├── carto
│   └── raw
├── liv3
├── output
│   ├── carto
│   └── graphique
└── README.md
```
---

## Dépendances

| Logiciel | Version |
|----------|---------|
| R | ≥ 4.5.2 |
| BirdNET | v1.5.1 (commit 4482cef, 2025-02-17) |

**Packages R :** Mettre à jour

---

## Code R

| Fichier | Fonction    |
|---------|-------------|
|`csv_check_mod9_2025.R`| Génère une table csv pour faciliter la validation des clips de 3s issus du script `extract_mod_lise_class9_2025_R8751.sh` |

---

### Code Bash
| Fichier | Fonction    |
|---------|-------------|
| `run_birdnet_2025_R8751.sh` | Analyse avec le modèle de base de BirdNET |
| `extract_mod_lise_class9_2025_R8751.sh` | Extraction des clips de 3s pour étape de validation de birdNET  |
| `run_mod_lise_class9_R8751_2025.sh` | Script pour analyser des fichiers accoustiques avec le modèle 'mod_lise_class9' |
| `epic_weather_2025_R8751.sh` | Script d'analyse des fichiers accoustiques avec 'mod_lise_class9' pour identifier les sites avec au moins un clip WEATHER  |


---
### Notes manipulation des bases de données

#### Observations de carcasses (Local : R8751/data/raw)

| Date Robin | Fichier concerné | Modification | Raison |
|---|---|---|---|
| 2026-07-22 | `inv_mort_2025.csv` | Suppression de l'inventaire GoPro du 2025-06-03 sur le tronçon 42 | Heures suspectes (09:37 à 09:38) ; inventaire non appuyé par d'autres méthodes alors que le tronçon compte déjà 2 autres inventaires GoPro. |
| 2026-07-22 | `inv_mort_2025.csv` | Suppression de l'inventaire GoPro du 2025-06-03 sur le tronçon 41 | Heures suspectes (09:39 à 09:40) ; inventaire non appuyé par d'autres méthodes alors que le tronçon compte déjà 2 autres inventaires GoPro. |
| 2026-07-23 | `persistance25.csv` | La valeur (31:31) dans la colonne TempsPredation signifie 31 h 31 (24 h 00 + 7 h 31) car la caméra est restée plus que 24 h 00 | la valeur affichée (31 h) et le format avec les () ne cadre pas avec la variable annoncée |

#### Données accoustiques (Serveur : MNT/AUDIO/MTQ-A10/AUDIOMOTHS/2025)

| Date Robin | Site | Arrêt réel | Nb de fichiers à supprimer | Fichier à partir duquel il faut supprimer | Nb de jours | Remarque |
|---|---|---|---|---|---|---|
|  2026-07-30 | T01  | 2025-10-26 |  164 | `20251026_180000.WAV` | 187 | Audiomoth récupéré le 26 octobre mais actif jusqu'au 11 novembre |
|  2026-07-30 | T20  | 2025-08-12 |  11 | `20250812_180000.WAV` | 107| Audiomoth récupéré le 12 mais actif jusqu'au 14 août |
|  2026-07-30 | T49\_1 |2025-08-01 |  - | - | - | Eloise avait marqué une autre date mais c'est bien 2025-08-01 |
|  2026-07-30 | T57  | 2025-08-12 |  11 | `20250812_180000.WAV` | 107 | Audiomoth récupéré le 12 mais actif jusqu'au 14 août|

#### Données d'inventaires des milieux humides (Local : R8751/data/raw)

| Date Robin | Site | Date observation | Taxon | Problème |
|---|---|---|---|---|
| 2026-08-03 | MH-T65 | 2025-07-28 | Anura | Donnée manquante ou perdue |
| 2026-08-03 | MH-T65 | 2025-07-28 | LICL | On ne comprend pas s'il y a des individus détectés au chant ou au visuel dans l'effectif |
| 2026-08-03 | MH-T20 | 2025-06-19 | NA | Site sans visite (tempête)|
| 2026-08-03 | MH-T41-1| 2025-06-12 | NA | Site sans visite pour cause de végétation |
| 2026-08-03 | MH-T41-1| 2025-08-04 | NA | Site sans visite pour cause de végétation |
| 2026-08-03 | MH-T41-2| 2025-06-12 | NA | On ne comprend pas si c'est un individu détecté au chant ou au visuel |
| 2026-08-03 | MH-T42-3| 2025-06-18 | LICL | On ne comprend pas s'il y a des individus détectés au chant ou au visuel dans l'effectif |
| 2026-08-03 | MH-T42-3| 2025-08-05 | LICL | On ne comprend pas s'il y a des individus détectés au chant ou au visuel dans l'effectif |
| 2026-08-03 | MH-T42-5| 2025-07-31 | DRVE | Aurore indique explicitement ne pas être sûr de l'identification et cette observation devrait donc être considérée comme anura sp. |
| 2026-08-03 | MH-T42-3| 2025-07-31 | NA| Inventaire incomplet pour ce site (trop de vase) |
| 2026-08-03 | MH-T47| 2025-07-28 | NA| Pas de deuxième inventaire puisqu'il y a des NAs dans toutes les colonnes (?) |
| 2026-08-03 | MH-T48| 2025-06-26 | NA| Milieu asséché sans observation d'herpétofaune (laissé en NA mais à voir si on veut le considérer comme un vrai zéro) |
| 2026-08-03 | MH-T48| 2025-07-31 | NA| Milieu asséché sans observation d'herpétofaune (laissé en NA mais à voir si on veut le considérer comme un vrai zéro) |
| 2026-08-03 | MH-T49| 2025-07-31 | NA| Étrange commentaire indiquant que seul le drone a été fait qu'ils n'ont pas fait d'inventaires alors qu'il y a 10 observations rattachées à ce site et à cette date |


Remarques générales : 
- Plusieurs commentaires font état d'espèce à déterminer. S'agissant de têtards il me paraît vain d'espérer aller plus loin. Autrement il faudrait demander à Éloïse d'actualiser les identifications.




