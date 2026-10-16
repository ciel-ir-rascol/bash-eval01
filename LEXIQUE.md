# Lexique des commandes Bash

Aide-mémoire autorisé pendant l'évaluation. Il rappelle **la syntaxe** des notions vues au TP01, mais pas ce qu'il faut en faire : à vous de choisir la bonne commande et de l'adapter.

Les exemples utilisent des noms fictifs (`capteur.sh`, `temperature`, `mesures/`…) qui ne sont pas ceux du sujet.

Pour le détail d'une commande : `man commande` (quitter avec `q`) ou `commande --help`.

---

## Se repérer dans le terminal

| Commande | Rôle |
| --- | --- |
| `pwd` | Affiche le dossier courant |
| `ls -l` | Liste le contenu du dossier (droits, taille, nom) |
| `cd dossier` | Se déplacer dans un dossier (`cd ..` : dossier parent, `cd ~` : dossier personnel) |
| `mkdir dossier` | Crée un dossier |
| `mkdir -p a/b` | Crée un dossier, **sans erreur s'il existe déjà** (et crée les parents si besoin) |
| `mv source destination/` | Déplace un fichier dans un dossier |
| `cat fichier` | Affiche le contenu d'un fichier |
| `nano fichier` | Édite un fichier (`Ctrl`+`O` puis `Entrée` : enregistrer, `Ctrl`+`X` : quitter) |
| `git clone git@github.com:pseudo/station-meteo.git` | Clone un dépôt GitHub en SSH dans le dossier courant |
| `git remote -v` | Affiche l'adresse du dépôt d'origine (`origin`) |

**Chemins** : `~` = votre dossier personnel, `.` = dossier courant, `..` = dossier parent.

## Lancer un script

| Commande | Rôle |
| --- | --- |
| `#!/bin/bash` | **Première ligne** du script : indique qu'il faut l'exécuter avec Bash |
| `chmod +x capteur.sh` | Rend le script exécutable |
| `./capteur.sh` | Lance le script du dossier courant |
| `./capteur.sh 12 salon` | Lance le script avec deux paramètres |
| `bash -x capteur.sh 12` | Lance le script en affichant chaque ligne exécutée (pour déboguer) |
| `echo $?` | Affiche le code retour de la commande précédente |
| `Ctrl`+`C` | Arrête un script bloqué |

## Variables et affichage

```bash
ville="Albi"                    # affectation : PAS d'espace autour du =
echo "Bonjour depuis $ville"    # utilisation : $ville, de préférence entre guillemets
echo "Bonjour $USER"            # $USER : login de la personne connectée

aujourdhui=$(date +%Y%m%d)      # $( ) : récupère le résultat d'une commande
echo "Fichier du $aujourdhui"   # → Fichier du 20261016
```

| Format de `date` | Exemple de résultat |
| --- | --- |
| `date +%Y%m%d` | `20261016` |
| `date +%d/%m/%Y` | `16/10/2026` |
| `date +%H:%M` | `14:05` |

## Paramètres du script

| Variable | Contenu |
| --- | --- |
| `$1`, `$2`… | Premier, deuxième… paramètre |
| `$#` | Nombre de paramètres reçus |
| `$0` | Nom du script |

```bash
# ./capteur.sh 12 salon   →   $1 = 12, $2 = salon, $# = 2
```

## Codes retour

```bash
exit 0      # arrête le script : tout s'est bien passé
exit 1      # arrête le script : erreur
```

## Calculs (nombres entiers)

```bash
total=$((a + b))            # + - * /   (division entière : 7 / 2 donne 3)
double=$((temperature * 2))
compteur=$((compteur + 1))  # ajouter 1
compteur=$((compteur - 1))  # retirer 1
echo "Résultat : $((a + 10))"
```

## Lire au clavier

```bash
read -p "Votre prénom : " prenom     # affiche la question, range la réponse dans $prenom
echo "Bonjour $prenom"
```

## Conditions

```bash
if [ condition ]; then
    commandes
elif [ autre_condition ]; then
    commandes
else
    commandes
fi
```

⚠️ **Espaces obligatoires** à l'intérieur des crochets : `[ $a -lt 10 ]`, jamais `[$a -lt 10]`.

| Comparer des **nombres** | Vrai si… |
| --- | --- |
| `[ $a -eq $b ]` | a égal à b |
| `[ $a -ne $b ]` | a différent de b |
| `[ $a -lt $b ]` | a < b |
| `[ $a -le $b ]` | a ≤ b |
| `[ $a -gt $b ]` | a > b |
| `[ $a -ge $b ]` | a ≥ b |

| Comparer des **textes** | Vrai si… |
| --- | --- |
| `[ "$a" = "$b" ]` | textes identiques |
| `[ "$a" != "$b" ]` | textes différents |
| `[ -z "$a" ]` | texte vide |

| Tester un **fichier** | Vrai si… |
| --- | --- |
| `[ -f "$f" ]` | `$f` existe et est un fichier |
| `[ -d "$d" ]` | `$d` existe et est un dossier |
| `[ ! -d "$d" ]` | `$d` **n'est pas** un dossier (le `!` inverse le test) |

Combiner deux tests : `[ $a -gt 0 ] && [ $a -lt 10 ]` (ET), `[ $a -lt 0 ] || [ $a -gt 10 ]` (OU).

## Boucles

```bash
# for : pour chaque valeur d'une liste
for jour in lundi mardi mercredi; do
    echo "Relevé du $jour"
done

# for avec seq : de 1 à 5
for i in $(seq 1 5); do
    echo "Mesure n°$i"
done

# for sur des fichiers : chaque fichier .csv du dossier mesures
for fichier in mesures/*.csv; do
    echo "Traitement de $fichier"
done

# while : tant que la condition est vraie
essai=1
while [ $essai -le 3 ]; do
    echo "Essai $essai"
    essai=$((essai + 1))
done
```

⚠️ Une boucle `while` dont la condition ne devient jamais fausse ne s'arrête pas : `Ctrl`+`C`.

## Noms de fichiers avec des espaces

Sans guillemets, `Rapport final.txt` est vu comme **deux** mots : `Rapport` et `final.txt`.

```bash
mv $fichier archives/       # ✗ casse sur les noms avec espaces
mv "$fichier" archives/     # ✓ toujours mettre les variables entre guillemets
```

## Erreurs fréquentes

| Message | Cause probable |
| --- | --- |
| `Permission denied` | Script non exécutable : `chmod +x` |
| `command not found` | `./` oublié devant le nom du script, ou espace autour du `=` (`a = 5`) |
| `[: missing ']'` | Espace manquant avant `]` |
| `integer expression expected` | Variable vide ou non numérique dans `-eq`, `-lt`… |
| `unary operator expected` | Variable vide dans un test : mettez-la entre guillemets |
| `No such file or directory` | Mauvais chemin : vérifiez avec `pwd` et `ls` |
