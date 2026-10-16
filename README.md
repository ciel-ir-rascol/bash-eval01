# Évaluation — Premiers scripts Bash

**1CIEL-IR — Durée : 1h30 — Validation par missions successives.**

> *Vous arrivez en renfort de l'équipe qui gère la salle **D116**. Elle a besoin de petits outils en Bash : connaître l'adresse d'un poste, afficher le plan d'adressage, protéger un accès par mot de passe et ranger les journaux qui s'accumulent. À vous d'écrire ces scripts.*

Rappel du plan d'adressage : le poste numéro **N** (de 1 à 20) a l'adresse **10.116.0.(100 + N)**. Le poste 7 a donc l'adresse `10.116.0.107`.

Cette évaluation porte sur les notions du **TP01 — Premiers scripts Bash** : `echo`, variables, paramètres (`$1`, `$#`), `read`, conditions `if`, comparaisons (`-eq`, `-lt`, `-gt`…), calculs `$(( ))`, boucles `for` et `while`, fichiers (`[ -d ]`, `mkdir`, `mv`) et codes retour (`exit`). **Elle ne contient rien qui n'ait été vu dans ce TP.**

---

## 🧭 Comment se déroule l'évaluation

> [!IMPORTANT]
> **Validation par missions successives**
>
> Un script de validation, `verifier.sh`, est fourni dans ce dépôt (vous le clonez en mission 1). À la fin de **chaque mission**, lancez-le avec le numéro de la mission :
> ```bash
> ~/eval-bash/bash-eval01/scripts/verifier.sh 2       # exemple pour la mission 2
> ```
> - Tant qu'il affiche `NON VALIDEE`, corrigez les points marqués `[ECHEC]` et relancez-le, autant de fois que nécessaire : ce n'est pas pénalisé.
> - Dès qu'il affiche **`MISSION N VALIDEE`**, **appelez l'enseignant** pour lui montrer le résultat : c'est lui qui reporte les points. **Une mission validée à l'écran mais jamais montrée ne compte pas.**
>
> Le script essaie vos programmes avec **d'autres valeurs que celles des exemples**, tirées au hasard : un script qui recopie l'exemple de l'énoncé ne passe pas. Lors de la validation, l'enseignant peut vous poser une question courte sur votre code.

Il n'y a **rien à rendre** : pas de commit, pas de push. Vos scripts restent dans votre dossier personnel.

### Environnement de travail

| | |
| --- | --- |
| **Poste** | Ubuntu Desktop 24.04 LTS du lycée, **dans votre session** |
| **Droits** | Aucun `sudo` nécessaire, rien à installer |
| **Éditeur** | `nano` (ou l'éditeur de votre choix) |
| **Dossier de travail** | `~/eval-bash/outils` (créé en mission 1) |

### Règles

- Vous avez droit à vos notes, au **sujet du TP01** et à vos scripts du TP01, à l'aide des commandes (`man`, `--help`) et au **[lexique des commandes](LEXIQUE.md)** fourni dans ce dépôt : on évalue votre capacité à écrire un script qui fonctionne, pas votre mémoire de la syntaxe.
- Travail **individuel**.
- Les noms de dossiers, de fichiers et les **messages affichés** doivent être respectés **à la lettre** : le script de validation ne fait pas d'approximation. Copiez-les depuis l'énoncé.
- Chaque script doit **commencer par `#!/bin/bash`** (c'est déjà le cas des fichiers fournis) et être **exécutable** (`chmod +x`).

---

## Sommaire et barème

| Mission | Objectif | Durée conseillée | Points |
| :---: | --- | :---: | :---: |
| **1** | Préparer son poste et écrire un premier script | 10 min | 2 |
| **2** | Adresse d'un poste (paramètre, conditions) | 15 min | 4 |
| **3** | Plan d'adressage (boucle `for`) | 15 min | 4 |
| **4** | Connexion par mot de passe (`read`, boucle `while`) | 20 min | 5 |
| **5** | Ranger les journaux (fichiers) | 25 min | 5 |
| | **Total** | **1h25** | **/20** |

Les missions se font **dans l'ordre**. Gardez 5 minutes de marge pour les validations.

---

## Mission 1 — Préparer son poste *(2 pts)*

1. Créez le dossier `~/eval-bash` et placez-vous dedans.
2. Clonez-y **ce dépôt** (le sujet), en HTTPS : `https://github.com/ciel-ir-rascol/bash-eval01.git`. Vous devez obtenir le dossier `~/eval-bash/bash-eval01`.
3. Lancez **une seule fois** le script qui prépare votre dossier de travail :
   ```bash
   ~/eval-bash/bash-eval01/scripts/preparer.sh
   ```
   Il crée **`~/eval-bash/outils`**, qui contient les 5 scripts à compléter : c'est là que se passe toute la suite.
4. Complétez **`bienvenue.sh`** pour qu'il affiche votre login et la date du jour, puis rendez-le exécutable :
   ```text
   $ ./bienvenue.sh
   Bienvenue lea-martin
   Nous sommes le 16/10/2026
   ```
   Le login ne doit pas être écrit en dur : utilisez la variable `$USER`. La date s'obtient avec la commande `date` (voir le lexique).

**✅ Validation :** `verifier.sh 1`

---

## Mission 2 — Adresse d'un poste *(4 pts)*

Complétez **`adresse.sh`** : il reçoit un **numéro de poste** en paramètre et affiche son adresse IP.

```text
$ ./adresse.sh 7
Poste 7 : 10.116.0.107

$ ./adresse.sh
Usage : ./adresse.sh NUMERO

$ ./adresse.sh 25
Erreur : le numéro de poste doit être entre 1 et 20
```

Le script doit :

1. vérifier qu'il a reçu **exactement un** paramètre ; sinon afficher le message `Usage : ./adresse.sh NUMERO` et s'arrêter avec le **code retour 1** ;
2. vérifier que le numéro est **entre 1 et 20** ; sinon afficher un message commençant par `Erreur` et s'arrêter avec le **code retour 1** ;
3. sinon, calculer l'adresse et afficher `Poste N : 10.116.0.X`, où X vaut 100 + N.

> [!TIP]
> Pour voir le code retour de la dernière commande : `echo $?`

**✅ Validation :** `verifier.sh 2`

---

## Mission 3 — Plan d'adressage *(4 pts)*

Complétez **`plan.sh`** : il reçoit un **nombre de postes** en paramètre et affiche l'adresse de chacun, du poste 1 à ce nombre, puis le total.

```text
$ ./plan.sh 3
Plan d'adressage de la salle D116
Poste 1 : 10.116.0.101
Poste 2 : 10.116.0.102
Poste 3 : 10.116.0.103
Total : 3 postes
```

Le script doit :

1. vérifier qu'il a reçu un paramètre ; sinon afficher `Usage : ./plan.sh NOMBRE` et s'arrêter avec le **code retour 1** ;
2. afficher une ligne `Poste N : 10.116.0.X` **par poste**, avec une **boucle** ;
3. terminer par la ligne `Total : N postes`.

> [!TIP]
> C'est le même principe que la table de multiplication du TP01.

**✅ Validation :** `verifier.sh 3`

---

## Mission 4 — Connexion par mot de passe *(5 pts)*

Complétez **`connexion.sh`** : il demande un mot de passe au clavier et laisse **3 essais** au maximum. Le mot de passe attendu est déjà rangé dans la variable `MOT_DE_PASSE` en haut du fichier : ne la modifiez pas.

```text
$ ./connexion.sh
Mot de passe : bonjour
Mot de passe incorrect, il reste 2 essai(s)
Mot de passe : Rascol81
Accès autorisé
```

```text
$ ./connexion.sh
Mot de passe : a
Mot de passe incorrect, il reste 2 essai(s)
Mot de passe : b
Mot de passe incorrect, il reste 1 essai(s)
Mot de passe : c
Accès bloqué
```

Le script doit :

1. demander le mot de passe avec `read`, **3 fois au maximum** ;
2. si le mot de passe est bon : afficher `Accès autorisé` et s'arrêter avec le **code retour 0** ;
3. après une erreur, s'il reste des essais : afficher `Mot de passe incorrect, il reste N essai(s)` ;
4. après 3 erreurs : afficher `Accès bloqué` et s'arrêter avec le **code retour 1**.

> [!TIP]
> C'est le même principe que le jeu « deviner un nombre » du TP01 : une boucle `while` et un compteur d'essais.

**✅ Validation :** `verifier.sh 4`

---

## Mission 5 — Ranger les journaux *(5 pts)*

Les captures de la salle s'entassent dans un même dossier. Complétez **`ranger.sh`** : il reçoit un **dossier** en paramètre et déplace tous les fichiers **`.log`** de ce dossier dans un sous-dossier **`archives`**. Les autres fichiers ne doivent pas bouger.

Un dossier d'exemple est fourni pour vos essais : `~/eval-bash/outils/captures`.

```text
$ ./ranger.sh captures
Archivé : captures/capture wifi.log
Archivé : captures/ping-dns.log
Archivé : captures/ping-passerelle.log
Fichiers archivés : 3

$ ls captures
archives  notes.txt  'rapport final.txt'  schema.png
```

Le script doit :

1. vérifier qu'il a reçu un paramètre ; sinon afficher `Usage : ./ranger.sh DOSSIER` et s'arrêter avec le **code retour 1** ;
2. vérifier que le dossier existe ; sinon afficher un message commençant par `Erreur` et s'arrêter avec le **code retour 1** ;
3. créer le sous-dossier `archives` dans le dossier (**sans erreur s'il existe déjà**) ;
4. déplacer chaque fichier `.log` du dossier dans `archives`, **y compris ceux dont le nom contient un espace** ;
5. terminer par la ligne `Fichiers archivés : N`, où N est le nombre de fichiers déplacés.

Pour retrouver le dossier d'exemple de départ après vos essais :

```bash
~/eval-bash/bash-eval01/scripts/preparer.sh --captures
```

> [!TIP]
> C'est le même principe que le renommage de fichiers du TP01 : une boucle `for` sur les fichiers, un `mv` et un compteur. Pensez aux guillemets autour des variables.

**✅ Validation :** `verifier.sh 5`

---

## 🆘 En cas de problème

| Symptôme | Cause probable | Solution |
| --- | --- | --- |
| `Permission denied` en lançant votre script | Script non exécutable | `chmod +x script.sh` |
| `command not found` en lançant votre script | `./` oublié | `./script.sh` (et non `script.sh`) |
| `preparer.sh` : `existe déjà` | Le script a déjà été lancé | Rien à faire, le dossier est prêt ; ne le supprimez pas |
| `No such file or directory` sur `verifier.sh` | Sujet cloné au mauvais endroit | Le sujet doit être dans `~/eval-bash/bash-eval01` |
| `[: missing ']'` | Espace manquant dans les crochets | `[ $a -lt 1 ]` : un espace après `[` et avant `]` |
| `integer expression expected` | Variable vide dans une comparaison | Vérifiez le nombre de paramètres **avant** de comparer |
| Le script attend sans rien afficher | Un `read` attend une saisie, ou une boucle ne s'arrête pas | `Ctrl`+`C`, puis vérifiez la condition de la boucle |
| `mv: cannot stat '…/*.log'` | Aucun fichier `.log` dans le dossier | Recréez le dossier d'exemple avec `preparer.sh --captures` |
| Le vérificateur indique `[ECHEC]` alors que « ça marche » | Message différent de l'énoncé | Comparez caractère par caractère (espaces, `:`, accents) |

---

*Licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr) — BTS CIEL option IR, Lycée Louis Rascol, Albi.*
