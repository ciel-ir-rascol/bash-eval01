# EVAL01 : Scripts Bash - Bases et manipulation de données

**Durée :** 3 heures
**Environnement :** Ubuntu Server 24.04 (VM VirtualBox)
**Rendu :** via GitHub Classroom (push de votre repository)

## Consignes générales

- **Travail individuel** : Cette évaluation est strictement individuelle
- **Documentation autorisée** : Vous pouvez consulter la documentation Bash, les man pages, et vos TPs précédents
- **Tests** : Chaque exercice dispose de tests automatisés pour valider votre solution
- **Barème** : Ex1 (5 pts) + Ex2 (5 pts) + Ex3 (6 pts) + Ex4 (8 pts) + Qualité (2 pts) = 26 pts → noté sur 20
- **Bonus** : Ex5 (+4 pts bonus)

## Structure du repository

```
votre-repo/
├── README.md              # Ce fichier
├── run_all_tests.sh      # Lance tous les tests
└── Exos/
    ├── ex1/              # Calculatrice simple
    │   ├── calculatrice.sh
    │   └── test_ex1.sh
    ├── ex2/              # Vérificateur de mot de passe
    │   ├── verif_password.sh
    │   └── test_ex2.sh
    ├── ex3/              # Analyseur de logs
    │   ├── analyser_logs.sh
    │   ├── test_ex3.sh
    │   └── test_logs/
    │       └── app.log (fourni)
    ├── ex4/              # Menu interactif
    │   ├── menu_calculs.sh
    │   └── test_ex4.sh
    └── ex5/              # BONUS - Compteur de fichiers
        ├── compteur_fichiers.sh
        └── test_ex5.sh
```

## Bonnes pratiques obligatoires

- **Shebang** : Tous vos scripts doivent commencer par `#!/bin/bash`
- **Permissions** : Rendez vos scripts exécutables : `chmod +x script.sh`
- **Commentaires** : Commentez votre code (variables, étapes importantes)
- **Gestion d'erreurs** : Vérifiez les paramètres et conditions d'exécution
- **Codes de retour** : Retournez 0 en cas de succès, 1 en cas d'erreur
- **Messages clairs** : Utilisez echo pour informer l'utilisateur

---

## Exo 1 : Calculatrice simple (5 pts) - 30 min

### Objectif

Créer un script `calculatrice.sh` qui effectue des opérations arithmétiques de base entre deux nombres.

### Utilisation

```bash
./calculatrice.sh 10 + 5
./calculatrice.sh 20 - 8
./calculatrice.sh 6 * 7
./calculatrice.sh 15 / 3
```

### Comportement attendu

```
Calcul : 10 + 5 = 15
```

```
Calcul : 20 - 8 = 12
```

```
Calcul : 6 * 7 = 42
```

```
Calcul : 15 / 3 = 5
```

### Spécifications techniques

1. **Vérifier que 3 paramètres sont fournis** (nombre1, opérateur, nombre2)
   - Si pas assez de paramètres : afficher un message d'erreur et retourner 1
   - Message : `Usage: ./calculatrice.sh <nombre1> <opérateur> <nombre2>`

2. **Vérifier que l'opérateur est valide** (+, -, *, /)
   - Si opérateur invalide : afficher une erreur et retourner 1
   - Message : `Erreur: Opérateur non valide. Utilisez +, -, * ou /`

3. **Effectuer le calcul** selon l'opérateur
   - Utiliser une structure `if/elif/else` ou `case`
   - Pour la multiplication : utiliser `\*` ou mettre `*` entre guillemets

4. **Gestion de la division par zéro**
   - Si division par 0 : afficher une erreur et retourner 1
   - Message : `Erreur: Division par zéro impossible`

5. **Afficher le résultat** au format : `Calcul : X opérateur Y = résultat`

### Commandes utiles

```bash
# Calculs en Bash
resultat=$((10 + 5))
resultat=$((nombre1 + nombre2))

# Accès aux paramètres
nombre1=$1
operateur=$2
nombre2=$3

# Nombre de paramètres
if [ $# -ne 3 ]; then
    echo "Pas assez de paramètres"
fi
```

### Barème (5 pts)

- Vérification 3 paramètres (1 pt)
- Vérification opérateur valide (1 pt)
- Calculs corrects pour +, -, * (1.5 pt)
- Division et gestion division par zéro (1 pt)
- Affichage correct du résultat (0.5 pt)

---

## Exo 2 : Vérificateur de mot de passe (5 pts) - 40 min

### Objectif

Créer un script `verif_password.sh` qui vérifie la robustesse d'un mot de passe selon plusieurs critères.

### Utilisation

```bash
./verif_password.sh "MonMotDePasse123"
```

### Comportement attendu

```
=== Vérification du mot de passe ===
Mot de passe : MonMotDePasse123

Critères de sécurité :
✓ Longueur suffisante (16 caractères, min: 8)
✓ Contient des majuscules
✓ Contient des minuscules
✓ Contient des chiffres
✗ Contient des caractères spéciaux

Score de sécurité : 4/5
Niveau : BON
```

### Critères de sécurité à vérifier

1. **Longueur** : Au moins 8 caractères
2. **Majuscules** : Au moins une lettre majuscule (A-Z)
3. **Minuscules** : Au moins une lettre minuscule (a-z)
4. **Chiffres** : Au moins un chiffre (0-9)
5. **Caractères spéciaux** : Au moins un caractère parmi !@#$%^&*()_+-=[]{}

### Niveaux de sécurité

- **Score 5/5** : EXCELLENT
- **Score 4/5** : BON
- **Score 3/5** : MOYEN
- **Score < 3** : FAIBLE

### Spécifications techniques

1. **Vérifier qu'un paramètre est fourni**
   - Si absent : afficher usage et retourner 1

2. **Tester chaque critère**
   - Pour chaque critère validé : incrémenter un compteur
   - Afficher ✓ si validé, ✗ si non validé

3. **Calculer le score** (nombre de critères validés)

4. **Afficher le niveau** selon le score

### Commandes utiles

```bash
# Longueur d'une chaîne
longueur=${#mot_de_passe}

# Tester la présence de majuscules
if [[ "$mot_de_passe" =~ [A-Z] ]]; then
    echo "Contient des majuscules"
fi

# Tester la présence de chiffres
if [[ "$mot_de_passe" =~ [0-9] ]]; then
    echo "Contient des chiffres"
fi

# Tester caractères spéciaux
if [[ "$mot_de_passe" =~ [!@#\$%\^&*()_+\-=\[\]{}] ]]; then
    echo "Contient des caractères spéciaux"
fi
```

### Barème (5 pts)

- Vérification du paramètre (0.5 pt)
- Test longueur (0.5 pt)
- Test majuscules/minuscules (1 pt)
- Test chiffres (0.5 pt)
- Test caractères spéciaux (1 pt)
- Calcul du score et affichage niveau (1.5 pt)

---

## Exo 3 : Analyseur de logs (6 pts) - 50 min

### Objectif

Créer un script `analyser_logs.sh` qui analyse un fichier de logs et génère des statistiques.

### Fichier de test fourni

Un fichier `test_logs/app.log` est fourni dans le dossier `Exos/ex3/`. Il contient des logs au format :

```
2025-12-07 10:15:32 INFO Application démarrée
2025-12-07 10:16:45 ERROR Connexion à la base de données échouée
2025-12-07 10:17:12 WARNING Mémoire faible (85%)
2025-12-07 10:18:03 INFO Utilisateur connecté: alice
2025-12-07 10:19:21 ERROR Fichier config.json introuvable
2025-12-07 10:20:15 INFO Sauvegarde effectuée
```

### Utilisation

```bash
./analyser_logs.sh test_logs/app.log
```

### Comportement attendu

```
=== Analyse du fichier de logs ===
Fichier : test_logs/app.log

Statistiques :
- Total de lignes : 6
- Nombre d'INFO : 3
- Nombre de WARNING : 1
- Nombre d'ERROR : 2

Résumé :
- Taux d'erreurs : 33%
- Dernière erreur : 2025-12-07 10:19:21 ERROR Fichier config.json introuvable
```

### Spécifications techniques

1. **Vérifier qu'un paramètre est fourni**
   - Si absent : afficher usage et retourner 1

2. **Vérifier que le fichier existe et est lisible**
   - Si inexistant ou illisible : afficher erreur et retourner 1

3. **Compter le nombre total de lignes**
   - Utiliser `wc -l`

4. **Compter les niveaux de log** (INFO, WARNING, ERROR)
   - Utiliser `grep -c` pour chaque niveau

5. **Calculer le taux d'erreurs** (en %)
   - Formule : `(nombre_erreurs * 100) / total_lignes`

6. **Afficher la dernière ligne d'erreur**
   - Utiliser `grep ERROR | tail -1`

### Commandes utiles

```bash
# Vérifier qu'un fichier existe
if [ ! -f "$fichier" ]; then
    echo "Fichier inexistant"
    exit 1
fi

# Compter les lignes
total=$(wc -l < "$fichier")

# Compter les occurrences
nb_info=$(grep -c "INFO" "$fichier")

# Obtenir la dernière ligne contenant ERROR
derniere_erreur=$(grep "ERROR" "$fichier" | tail -1)

# Calcul avec division entière
taux=$(( nb_erreurs * 100 / total ))
```

### Barème (6 pts)

- Vérification paramètre et fichier (1 pt)
- Comptage total lignes (0.5 pt)
- Comptage INFO (0.5 pt)
- Comptage WARNING (0.5 pt)
- Comptage ERROR (0.5 pt)
- Calcul taux d'erreurs (1.5 pt)
- Affichage dernière erreur (1.5 pt)

---

## Exo 4 : Menu interactif de calculs (8 pts) - 60 min

### Objectif

Créer un script `menu_calculs.sh` qui propose un menu interactif pour effectuer différents calculs sur une liste de nombres.

### Utilisation

```bash
./menu_calculs.sh
```

### Comportement attendu

```
====================================
    MENU DE CALCULS STATISTIQUES
====================================

Entrez une liste de nombres séparés par des espaces :
> 5 10 15 20 25

====================================
Que souhaitez-vous calculer ?
====================================
1) Somme
2) Moyenne
3) Minimum
4) Maximum
5) Quitter
====================================
Votre choix : 2

Résultat : La moyenne est 15

[Le menu se réaffiche pour un nouveau calcul...]
```

### Fonctionnalités à implémenter

#### 1. Somme
Additionner tous les nombres de la liste.

#### 2. Moyenne
Calculer la moyenne : `somme / nombre_d_éléments`

#### 3. Minimum
Trouver le plus petit nombre de la liste.

#### 4. Maximum
Trouver le plus grand nombre de la liste.

#### 5. Quitter
Quitter le programme proprement.

### Spécifications techniques

1. **Demander une liste de nombres**
   - Utiliser `read` pour lire l'entrée utilisateur
   - Stocker les nombres dans un tableau

2. **Afficher le menu**
   - Utiliser une structure `case` pour gérer les choix

3. **Boucle principale**
   - Le menu doit se répéter après chaque calcul
   - Jusqu'à ce que l'utilisateur choisisse "Quitter"

4. **Validation basique**
   - Vérifier qu'au moins un nombre est entré
   - Gérer le choix invalide (afficher un message)

### Algorithmes suggérés

```bash
# Lire la liste de nombres dans un tableau
read -p "Entrez des nombres : " -a nombres

# Calculer la somme
somme=0
for nombre in "${nombres[@]}"; do
    somme=$((somme + nombre))
done

# Trouver le minimum
min=${nombres[0]}
for nombre in "${nombres[@]}"; do
    if [ $nombre -lt $min ]; then
        min=$nombre
    fi
done

# Menu avec case
case $choix in
    1) echo "Calcul de la somme..." ;;
    2) echo "Calcul de la moyenne..." ;;
    *) echo "Choix invalide" ;;
esac
```

### Barème (8 pts)

- Lecture et stockage des nombres (1 pt)
- Menu avec structure case (1.5 pt)
- Calcul de la somme (1 pt)
- Calcul de la moyenne (1.5 pt)
- Recherche du minimum (1.5 pt)
- Recherche du maximum (1 pt)
- Boucle et gestion quitter (0.5 pt)

---

## Exo 5 BONUS : Compteur de fichiers par type (4 pts) - 30 min

### Objectif

Créer un script `compteur_fichiers.sh` qui compte et affiche le nombre de fichiers par extension dans un dossier.

### Utilisation

```bash
./compteur_fichiers.sh /chemin/vers/dossier
```

### Comportement attendu

```
=== Compteur de fichiers ===
Dossier analysé : /home/user/Documents

Fichiers par extension :
  .txt  : 8 fichiers
  .sh   : 3 fichiers
  .jpg  : 5 fichiers
  .pdf  : 2 fichiers

Total : 18 fichiers
```

### Spécifications techniques

1. **Vérifier qu'un paramètre est fourni**
   - Si absent : afficher usage et retourner 1

2. **Vérifier que le dossier existe**
   - Utiliser `[ -d "$dossier" ]`

3. **Lister tous les fichiers** (pas les dossiers)
   - Utiliser `find` avec `-type f`

4. **Extraire les extensions**
   - Pour chaque fichier : extraire l'extension
   - Compter le nombre de fichiers par extension

5. **Afficher les résultats**
   - Trier par extension ou par fréquence

### Algorithme suggéré

```bash
# Parcourir tous les fichiers
for fichier in $(find "$dossier" -type f); do
    # Extraire l'extension
    extension="${fichier##*.}"

    # Compter (utiliser un tableau associatif ou des variables)
done

# Afficher les résultats
```

### Commandes utiles

```bash
# Extraire l'extension d'un fichier
fichier="document.txt"
extension="${fichier##*.}"    # Résultat: txt

# Parcourir les fichiers d'un dossier
find /dossier -type f

# Tableaux associatifs (Bash 4+)
declare -A compteurs
compteurs["txt"]=5
echo ${compteurs["txt"]}
```

### Barème BONUS (4 pts)

- Vérification paramètre et dossier (0.5 pt)
- Utilisation correcte de find (1 pt)
- Extraction des extensions (1 pt)
- Comptage par extension (1 pt)
- Affichage formaté (0.5 pt)

---

## Tests automatisés

### Tester un exercice spécifique

```bash
cd Exos/ex1
chmod +x calculatrice.sh test_ex1.sh
./test_ex1.sh
```

### Tester tous les exercices

```bash
chmod +x run_all_tests.sh
./run_all_tests.sh
```

---

## Rendu de l'évaluation

### Commits Git

Faites des commits réguliers :

```bash
git add Exos/ex1/
git commit -m "Ex1: Calculatrice terminée"

git add Exos/ex2/
git commit -m "Ex2: Vérificateur de mot de passe terminé"

git push origin main
```

### Checklist finale

Avant de rendre votre travail, vérifiez :

- [ ] Tous les scripts commencent par `#!/bin/bash`
- [ ] Tous les scripts sont exécutables
- [ ] Tous les scripts sont commentés
- [ ] Les tests passent (au moins partiellement)
- [ ] Tous vos fichiers sont committés et pushés

---

## Barème récapitulatif

| Exercice | Points | Durée | Type |
|----------|--------|-------|------|
| Ex1 : Calculatrice simple | 5 pts | 30 min | Facile |
| Ex2 : Vérificateur mot de passe | 5 pts | 40 min | Facile |
| Ex3 : Analyseur de logs | 6 pts | 50 min | Moyen |
| Ex4 : Menu interactif | 8 pts | 60 min | Moyen |
| Qualité du code | 2 pts | - | - |
| **TOTAL Obligatoire** | **26 pts** | **3h** | - |
| Ex5 : Compteur fichiers (BONUS) | +4 pts | 30 min | Moyen |

**Note finale** = (Score obtenu / 26) × 20

### Critères de qualité du code (2 pts)

- **Commentaires** (0.5 pt) : Code bien commenté, variables et étapes importantes expliquées
- **Bonnes pratiques** (0.5 pt) : Shebang présent, gestion d'erreurs cohérente
- **Lisibilité** (0.5 pt) : Indentation correcte, noms de variables explicites
- **Originalité** (0.5 pt) : Solutions élégantes ou optimisations pertinentes

**Temps recommandé** : ~20 min pour relecture et tests finaux

---

## Aide et ressources

### Documentation autorisée

- `man bash`
- `man grep`
- `man find`
- Vos TPs précédents (TP01 et TP02)
- Cours en ligne : https://ciel-ir-rascol.github.io/linux/05-Scripts_bash/

### En cas de blocage

1. Lisez attentivement l'énoncé et les exemples
2. Testez vos commandes ligne par ligne dans le terminal
3. Utilisez les tests automatisés pour valider progressivement
4. Commentez votre code pour expliquer votre démarche

---

**Bon courage ! 🚀**
