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

#### Observations de carcasses

| Date de suppression | Fichier concerné | Modification | Raison |
|---|---|---|---|
| 2026-07-22 | `inv_mort_2025.csv` | Suppression de l'inventaire GoPro du 2025-06-03 sur le tronçon 42 | Heures suspectes (09:37 à 09:38) ; inventaire non appuyé par d'autres méthodes alors que le tronçon compte déjà 2 autres inventaires GoPro. |
| 2026-07-22 | `inv_mort_2025.csv` | Suppression de l'inventaire GoPro du 2025-06-03 sur le tronçon 41 | Heures suspectes (09:39 à 09:40) ; inventaire non appuyé par d'autres méthodes alors que le tronçon compte déjà 2 autres inventaires GoPro. |
| 2026-07-23 | `persistance25.csv` | La valeur (31:31) dans la colonne TempsPredation signifie 31 h 31 (24 h 00 + 7 h 31) car la caméra est restée plus que 24 h 00 | la valeur affichée (31 h) et le format avec les () ne cadre pas avec la variable annoncée |

#### Données accoustiques (MNT/AUDIO/MTQ-A10/AUDIOMOTHS/2025)

| Date note | Site | Arrêt réel | Nb de fichiers à supprimer | Fichier à partir duquel il faut supprimer | Nb de jours | Remarque |
|---|---|---|---|---|---|---|

|  2026-07-30 | T01  | 2025-10-26 |  164 | `20251026_180000.WAV` | 187 | Audiomoth récupéré le 26 octobre mais actif jusqu'au 11 novembre |
|  2026-07-30 | T20  | 2025-08-12 |  11 | `20250812_180000.WAV` | 107| Audiomoth récupéré le 12 mais actif jusqu'au 14 août |
|  2026-07-30 | T49\_1 |2025-08-01 |  - | - | - | Eloise avait marqué une autre date mais c'est bien 2025-08-01 |
|  2026-07-30 | T57  | 2025-08-12 |  11 | `20250812_180000.WAV` | 107 | Audiomoth récupéré le 12 mais actif jusqu'au 14 août|

