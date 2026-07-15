# Projet R875.1 - Montérégie, 2024-2027





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
| BirdNET | à définir |

**Packages R :** `dplyr`, `ggplot2`, `ggvegan`, `lubridate`, `parallel`, `readr`, `tzdb`, `vegan`, `vroom`

---

## Code R

| Fichier | Fonction    |
|---------|-------------|
| 

---

### Code Bash
| Fichier | Fonction    |
|---------|-------------|
| `run_birdnet.sh` | Analyse avec le modèle de base de BirdNET |
| `extract_birdnet.sh` | Script d'extraction des clips des fichiers accoustiques pour validation (birdnet de base) |
| `run_mod_lise_class9.sh` | Script pour analyser des fichiers accoustiques avec le modèle 'mod_lise_class9' |
| `extract_mod_lise_class9.sh` | Script d'extraction des clips des fichiers accoustiques pour validation ('mod_lise_class9') |
| `epic_weather.sh` | Script d'analyse des fichiers accoustiques avec 'mod_lise_class9' pour identifier les sites avec au moins un clip WEATHER  |
| `rename_wav.sh` | À voir si le script est encore utile |
| `connection.sh` / `connection_rob.sh` | Script avec plusieurs options de connexions SSH au serveur distant |

---

