# Projet R875.1, 2024-2027





---

## Structure du projet
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
|`csv_check_mod9_2025.R`| Génère une table csv pour faciliter la validation des clips de 3s issus du script |

---

### Code Bash
| Fichier | Fonction    |
|---------|-------------|
| `run_birdnet_2025_R8751.sh` | Analyse avec le modèle de base de BirdNET |
| `extract_mod_lise_class9_2025_R8751.sh` | Extraction des clips de 3s pour étape de validation de birdNET  |
| `run_mod_lise_class9_R8751_2025.sh` | Script pour analyser des fichiers accoustiques avec le modèle 'mod_lise_class9' |
| `epic_weather_2025_R8751.sh` | Script d'analyse des fichiers accoustiques avec 'mod_lise_class9' pour identifier les sites avec au moins un clip WEATHER  |


---

