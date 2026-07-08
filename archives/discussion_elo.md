# Discussion avec Éloïse — Résultats et méthodologie R875.1 (2025/2026)

> **Réunion :** 2026-07-06

---

## 1. Méthodes

### 1.1 Observations de carcasses à l'aide de trois techniques

#### Dispositif des inventaires de mortalité

Trois méthodes étaient appliquées (à pied, GoPro et drone) à chaque site sur l'ensemble des deux visites. L'enregistrement par GoPro était systématiquement effectué, mais l'utilisation des deux autres méthodes (à pied et drone) dépendait du contexte.

**Cas de figure 1 -- Absence d'autorisation légale pour le drone**

| Visite | Méthodes |
|--------|----------|
| Première visite | Inventaires à pied + enregistrement par GoPro |
| Deuxième visite | Inventaires à pied + enregistrement par GoPro |

**Cas de figure 2 -- Autorisation légale pour le drone et possibilité de marcher à pied le long du tronçon de façon sécuritaire**

*Option a) Conditions de vol optimales pour le drone dès la première visite*

Lors de la première visite, le drone est réalisé en premier. Lors de la deuxième visite, l'inventaire à pied et l'enregistrement par GoPro sont réalisés.

*Option b) Conditions de vol mauvaises pour le drone lors de la première visite*

Lors de la première visite, l'inventaire à pied et l'enregistrement par GoPro sont réalisés. Lors de la deuxième visite, le drone et la GoPro sont réalisés.

**Cas de figure 2 -- Autorisation légale pour le drone et impossibilité de marcher à pied le long du tronçon de façon sécuritaire**

| Visite | Méthodes |
|--------|----------|
| Première visite | Inventaires drone (si conditions ok) + enregistrement par GoPro |
| Deuxième visite | Inventaires drone (si conditions ok) + enregistrement par GoPro |

> **IMPORTANT :** En 2026, les inventaires drones ne sont plus réalisés.

#### Zone délimitée pour les inventaires de carcasses

Bien que les observateurs ne cherchent pas à inventorier les fossés, ceux-ci n'ont pas de limite de distance pour noter les carcasses sur le tronçon routier. Cela fait en sorte que si les observateurs marchent dans l'herbe et qu'ils détectent une carcasse en dehors de l'accotement dur et des voies, celle-ci est tout de même consignée.

En 2025, la position des carcasses n'était pas consignée, ce qui ne permet pas de retirer a posteriori les mentions des carcasses dans la zone enherbée. Pour 2026, cette information est consignée.

#### Déroulement d'un inventaire à pied

S'il est possible de traverser de manière sécuritaire la ou les voies, alors les observateurs pouvaient parcourir la route dans les deux sens de circulation. Il n'y a pas eu de double comptage puisque, dans ce cas de figure, les carcasses de la voie opposée n'étaient pas comptabilisées.

À noter que, dans les tables, il n'y a pas de distinction entre les inventaires des deux voies. Les données sont consignées par tronçon. Donc, s'il y a eu deux voies échantillonnées de façon indépendante, l'inventaire est regroupé sous un seul tronçon.

Dans le cas de figure où il est impossible de traverser à pied, alors les observateurs faisaient l'inventaire en marchant sur une seule voie. Dans ce cas-là, les carcasses observées sur la voie opposée étaient consignées.

#### Déroulement d'un inventaire en GoPro

Pour l'inventaire des carcasses avec GoPro (2025 et 2026), l'effort sur le tronçon consistait à faire les deux voies au complet.

#### Gestion des waypoints

Pour l'inventaire à pied (2025 et 2026), les GPX sont pris pour chaque carcasse, mais ne sont pas repris lorsqu'il s'agit d'une carcasse déjà répertoriée. Toutefois, Éloïse indique dans le carnet la carcasse qui est détectée à chaque itération d'inventaire. Il est donc théoriquement possible de reconstituer une base de données avec des coordonnées géographiques à chaque observation.

Pour l'inventaire en voiture, aucun point GPX n'est pris en parallèle de l'enregistrement GoPro.

#### Gestion des déchets

En 2025, les déchets étaient inventoriés durant les inventaires GoPro en voiture. C'était une tâche difficile à maintenir dans le contexte de ce terrain.

### 1.2 Sélection des tronçons

Dispositif de départ en 2025 : 3 catégories, 10 tronçons par catégorie = **30 tronçons**.

Éloïse s'est rendu compte qu'il y avait une mauvaise classification de certains tronçons et, après un travail de reclassification et de sélection de nouveaux sites, le dispositif corrigé pour 2025-2026 est le suivant : **48 sites différents**, dont **12 sites** qui ont été suivis sur 2 ans, avec **16 sites par catégorie**.

### 1.3 Persistance

Une cible de 2 tests par tronçon par saison pour la persistance, mais en pratique il n'est pas possible d'en faire autant. Au final, il est juste prévu de faire le plus de tests possible en respectant le dispositif des 2 tests à chaque expérience.

---

## 2. Fichiers 2025

### 2.1 `INV_ANOURES_POISSONS_RMM_2025.xlsx`

Les œufs inscrits dans cette table ne correspondent pas à des masses, mais à une estimation visuelle du nombre d'œufs. Ce n'est pas la convention habituelle (voir réf. ou les mémoires avec des méthodes impliquant des décomptes de masses pour l'effort reproducteur).

Les données ne sont pas à jour et il manque des observations du deuxième auxiliaire (Chanel Montemiglio ; chanel.montemiglio.1@ulaval.ca). Ces données ne sont pas accessibles dans un carnet puisque, apparemment, Chanel utilisait son propre cellulaire pour consigner les données. Les données sont en cours de mise à jour.

Un milieu humide (site) correspond à un milieu humide proche du tronçon et qui a été sélectionné par Aurore.

**Colonne `Équipe`**

1 et 2 = 1 équipe, car les limites de l'étang n'étaient pas claires (mais en 2026 tous les décomptes sont des comptages individuels indépendants).

Pour les cas d'animaux non identifiés, il y a parfois des images, mais les fichiers ne sont pas traçables.

**Colonne `Stade`**

Les mues d'écrevisse sont bien des mues et non des individus.

Les inventaires n'ont pas été effectués lorsqu'il y avait trop de végétation (rare).

Les anoures chanteurs pouvaient être comptabilisés s'il était avéré qu'il s'agissait d'un nouvel individu (pas de contact visuel).

### 2.2 `INV_MORTALITE_2025_RMM.xlsx`

#### Feuille `DATA_INV_2025`

Sites et tronçons sont la même chose.

Pas mal de valeurs manquantes dans les variables sur les conditions d'observation. Ces données sont potentiellement dans les carnets, mais pas disponibles maintenant.

#### Feuille `Obs_jumelles`

Il manque les waypoints. Ils sont potentiellement dans les carnets, mais pas disponibles.

L'état de la carcasse est rarement spécifié. Il n'y a pas eu de clarification de quand ou comment noter les classes pour l'état en amont, d'où les difficultés sur le terrain.

Pas d'informations sur l'emplacement des carcasses en 2025 (pris parfois dans le carnet), mais ok pour 2026.

La direction (voie) n'est pas dans la table, mais il est possible d'avoir l'information quand cela s'applique.

#### Feuille `Obs_GoPro`

**Colonne `Heure_debut`** = localisation en minutage de la carcasse, avec un format en minutes:secondes.

**Colonne `Heure_obs`** = heure en format heures:minutes.

La table n'est pas complètement remplie. Certaines cellules sont des 0 et d'autres sont vides. Il y a un travail de vérification à faire par Éloïse sur les données de 2025.

### 2.3 `PERSISTANCE_RMM_2025_a_trier.xlsx`

#### Feuille `data_clean`

Dans les colonnes `Prédateur` et `NomFichierPhoto`, il y a plusieurs mentions `IND`.

`IND` = prédation sans photo.

### 2.4 `Points_GPS_a_trier.xlsx`

#### Feuille `data_brutes`

**Colonne `ele`** = données issues des informations sur le niveau d'élévation.

**Colonne `Name_waypoint`** = les valeurs numériques sont des débris.

#### Feuille `faune vivante`

La table n'est pas à jour. Il manque des identifiants de tronçons (colonne `Tronçon_ID`).

Il manque aussi des valeurs pour les variables sur les conditions d'observation (pas urgent).

#### Feuille `QField`

Des données de QField se mélangent avec les waypoints. Il faut clarifier cela, sinon je ne peux rien en tirer.

### 2.5 `STATIONS_REPTILES_2025.xlsx`

La colonne `Presence` contient des décomptes.

Sinon, la table est ok.
