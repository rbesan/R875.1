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



