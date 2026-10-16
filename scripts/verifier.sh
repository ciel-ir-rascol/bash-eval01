#!/bin/bash
#
# verifier.sh — Validation des missions de l'evaluation Bash (bash-eval01)
# A executer SUR LE POSTE, en utilisateur normal (pas de sudo) :
#     ~/eval-bash/bash-eval01/scripts/verifier.sh N        (N = numero de mission, 1 a 5)
#
# Le script ne modifie rien dans ~/eval-bash : il lance les scripts de l'etudiant
# sur des valeurs tirees au hasard, dans un dossier temporaire supprime a la fin.
#

BASE="$HOME/eval-bash"
SUJET="$BASE/bash-eval01"
OUTILS="$BASE/outils"
MOT_DE_PASSE="Rascol81"

MISSION="$1"
SCORE=0
TOTAL=0

VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
GRAS="\033[1m"
RAZ="\033[0m"

if [ "$(id -u)" -eq 0 ]; then
    echo "Ne lancez pas ce script avec sudo : relancez-le en utilisateur normal." >&2
    exit 1
fi

case "$MISSION" in
    1|2|3|4|5) ;;
    *) echo "Usage : $0 N     (N = numéro de la mission, de 1 à 5)" >&2; exit 1 ;;
esac

BAC="$(mktemp -d)"
trap 'rm -rf "$BAC"' EXIT

titre() {
    echo
    echo -e "${GRAS}=== $1 ===${RAZ}"
}

# ok <description> <commande...>  -> +1 si la commande reussit
ok() {
    local desc="$1"; shift
    TOTAL=$((TOTAL + 1))
    if "$@" >/dev/null 2>&1; then
        echo -e "  [${VERT}OK${RAZ}]     $desc"
        SCORE=$((SCORE + 1))
    else
        echo -e "  [${ROUGE}ECHEC${RAZ}]  $desc"
    fi
}

info() { echo -e "  [${JAUNE}INFO${RAZ}]   $1"; }

bilan() {
    echo
    if [ "$SCORE" -eq "$TOTAL" ]; then
        echo -e "${VERT}${GRAS}MISSION $MISSION VALIDEE${RAZ} ($SCORE / $TOTAL) — appelez l'enseignant pour la faire constater."
    else
        echo -e "${ROUGE}${GRAS}MISSION $MISSION NON VALIDEE${RAZ} ($SCORE / $TOTAL) — corrigez les points en ECHEC, puis relancez le script."
    fi
    exit 0
}

# --- Lancement des scripts de l'etudiant -----------------------------------------

# lance <script> [args...] : execute ~/eval-bash/outils/<script> sans clavier,
# 5 secondes maximum. Resultat dans SORTIE (stdout + stderr) et CODE.
lance() {
    local s="$OUTILS/$1"; shift
    SORTIE=$(cd "$BAC" && timeout 5 "$s" "$@" </dev/null 2>&1)
    CODE=$?
}

# saisie <lignes> <script> [args...] : idem, en tapant <lignes> au clavier
# (une saisie par ligne, separees par \n)
saisie() {
    local entree="$1" s="$OUTILS/$2"; shift 2
    SORTIE=$(cd "$BAC" && printf '%b\n' "$entree" | timeout 5 "$s" "$@" 2>&1)
    CODE=$?
}

contient()  { echo "$SORTIE" | grep -qiE "$1"; }
echec()     { [ "$CODE" -ne 0 ] && [ "$CODE" -ne 124 ]; }   # 124 = bloque (timeout)
succes()    { [ "$CODE" -eq 0 ]; }
hasard()    { echo $(( RANDOM % ($2 - $1 + 1) + $1 )); }     # entier entre $1 et $2

executable(){ [ -f "$OUTILS/$1" ] && [ -x "$OUTILS/$1" ]; }
shebang()   { head -1 "$OUTILS/$1" | grep -q '^#!/bin/bash'; }

# --- Mission 1 : bienvenue.sh ----------------------------------------------------

sujet_clone()      { git -C "$SUJET" config --get remote.origin.url | grep -Eq 'ciel-ir-rascol/bash-eval01(\.git)?$'; }
outils_prepares()  { [ -f "$OUTILS/.eval-bash" ]; }
bienvenue_login()  { lance bienvenue.sh; succes && contient "Bienvenue $(id -un)"; }
bienvenue_date()   { lance bienvenue.sh; echo "$SORTIE" | grep -qF "$(date +%d/%m/%Y)"; }

# --- Mission 2 : adresse.sh ------------------------------------------------------

# ligne_poste <n> : la ligne « Poste n : 10.116.0.(100+n) » est affichee
ligne_poste()      { contient "Poste $1 ?: ?10\.116\.0\.$((100 + $1))([^0-9]|$)"; }

adresse_usage()    { lance adresse.sh;        echec && contient "usage"; }
adresse_deux()     { lance adresse.sh 3 4;    echec; }
adresse_zero()     { lance adresse.sh 0;      echec && contient "erreur"; }
adresse_trop()     { lance adresse.sh 21;     echec && contient "erreur"; }
adresse_hasard()   { local n; n=$(hasard 2 19); lance adresse.sh "$n"; succes && ligne_poste "$n"; }
adresse_bornes()   { lance adresse.sh 1 && succes && ligne_poste 1 && lance adresse.sh 20 && succes && ligne_poste 20; }

# --- Mission 3 : plan.sh ---------------------------------------------------------

plan_usage()       { lance plan.sh; echec && contient "usage"; }

# plan_liste <n> : exactement n lignes « Poste i : ... », de 1 a n, dans l'ordre
plan_liste() {
    local n="$1" i attendu obtenu
    lance plan.sh "$n"
    succes || return 1
    attendu=$(for i in $(seq 1 "$n"); do echo "Poste $i : 10.116.0.$((100 + i))"; done)
    obtenu=$(echo "$SORTIE" | grep -E '^ *Poste [0-9]+ ?:' | sed -E 's/^ +//; s/ *: */ : /; s/ +$//')
    [ "$attendu" = "$obtenu" ]
}
plan_hasard()      { plan_liste "$(hasard 4 15)"; }
plan_un()          { plan_liste 1; }
plan_total()       { local n; n=$(hasard 4 15); lance plan.sh "$n"; contient "Total ?: ?$n postes?"; }

# --- Mission 4 : connexion.sh ----------------------------------------------------

connexion_premier(){ saisie "$MOT_DE_PASSE" connexion.sh; succes && contient "autoris"; }
connexion_second() { saisie "erreur\n$MOT_DE_PASSE" connexion.sh; succes && contient "autoris" && contient "il reste 2"; }
connexion_decompte(){ saisie "a\nb\nc" connexion.sh; contient "il reste 2" && contient "il reste 1"; }
connexion_bloque() { saisie "a\nb\nc" connexion.sh; echec && contient "bloqu" && ! contient "autoris"; }
# Un 4e essai (correct) ne doit plus etre lu : 3 essais maximum
connexion_trois()  { saisie "a\nb\nc\n$MOT_DE_PASSE" connexion.sh; echec && ! contient "autoris"; }

# --- Mission 5 : ranger.sh -------------------------------------------------------

# Cree un dossier de captures tire au hasard : NB_LOG fichiers .log (dont un
# avec un espace dans le nom) et des fichiers qui ne doivent pas bouger.
captures() {
    local d="$1" i
    mkdir -p "$d"
    NB_LOG=$(hasard 3 6)
    for i in $(seq 2 "$NB_LOG"); do echo "ping $i" > "$d/ping-$RANDOM-$i.log"; done
    echo "trame" > "$d/capture wifi.log"
    echo "notes" > "$d/notes.txt"
    echo "png"   > "$d/schema.png"
    echo "texte" > "$d/rapport final.txt"
}
reste_en_place()   { [ -f "$1/notes.txt" ] && [ -f "$1/schema.png" ] && [ -f "$1/rapport final.txt" ]; }
nb_fichiers()      { local d="$1"; shift; ls -1 "$d" 2>/dev/null | grep -c "$@"; }   # nb_fichiers <dossier> [-v] <motif>

ranger_usage()     { lance ranger.sh; echec && contient "usage"; }
ranger_absent()    { lance ranger.sh "$BAC/dossier-inexistant"; echec && contient "erreur"; }
ranger_logs() {
    local d="$BAC/c1"; captures "$d"
    lance ranger.sh "$d"
    succes && [ -d "$d/archives" ] \
        && [ "$(nb_fichiers "$d/archives" '\.log$')" -eq "$NB_LOG" ] \
        && [ -f "$d/archives/capture wifi.log" ] \
        && [ "$(nb_fichiers "$d" '\.log$')" -eq 0 ]
}
ranger_autres() {
    local d="$BAC/c2"; captures "$d"
    lance ranger.sh "$d"
    succes && [ -d "$d/archives" ] && reste_en_place "$d" \
        && [ "$(nb_fichiers "$d/archives" -v '\.log$')" -eq 0 ]
}
ranger_total()     { local d="$BAC/c3"; captures "$d"; lance ranger.sh "$d"; contient "archiv[^:]*: ?$NB_LOG([^0-9]|$)"; }
ranger_existe() {
    local d="$BAC/c4"; captures "$d"; mkdir "$d/archives"
    lance ranger.sh "$d"
    succes && [ "$(nb_fichiers "$d/archives" '\.log$')" -eq "$NB_LOG" ]
}

# --- Verifications ---------------------------------------------------------------

echo -e "${GRAS}Évaluation Bash — vérification de la mission $MISSION${RAZ}"

# Prerequis communs aux missions 2 a 5 : le dossier de travail a ete prepare
if [ "$MISSION" -ge 2 ] && ! outils_prepares; then
    echo -e "  [${ROUGE}ECHEC${RAZ}]  $OUTILS n'existe pas ou n'a pas été créé par preparer.sh : terminez d'abord la mission 1."
    TOTAL=1
    bilan
fi

case "$MISSION" in
1)
    titre "Mission 1 — Préparer son poste"
    ok "Sujet cloné dans ~/eval-bash/bash-eval01"       sujet_clone
    ok "Dossier ~/eval-bash/outils préparé"             outils_prepares
    ok "bienvenue.sh commence par #!/bin/bash"          shebang bienvenue.sh
    ok "bienvenue.sh est exécutable"                    executable bienvenue.sh
    ok "Affiche « Bienvenue $(id -un) »"                bienvenue_login
    ok "Affiche la date du jour ($(date +%d/%m/%Y))"    bienvenue_date
    ;;
2)
    titre "Mission 2 — Adresse d'un poste"
    ok "adresse.sh est exécutable"                      executable adresse.sh
    ok "Sans paramètre : message Usage et code retour 1" adresse_usage
    ok "Avec deux paramètres : code retour 1"           adresse_deux
    ok "Poste 0 : message d'erreur et code retour 1"    adresse_zero
    ok "Poste 21 : message d'erreur et code retour 1"   adresse_trop
    ok "Poste tiré au hasard : adresse correcte"        adresse_hasard
    ok "Postes 1 et 20 acceptés"                        adresse_bornes
    ;;
3)
    titre "Mission 3 — Plan d'adressage"
    ok "plan.sh est exécutable"                         executable plan.sh
    ok "Sans paramètre : message Usage et code retour 1" plan_usage
    ok "Nombre de postes tiré au hasard : liste complète et correcte" plan_hasard
    ok "Un seul poste : une seule ligne"                plan_un
    ok "Ligne « Total : N postes »"                     plan_total
    ;;
4)
    titre "Mission 4 — Connexion"
    ok "connexion.sh est exécutable"                    executable connexion.sh
    ok "Bon mot de passe du premier coup : accès autorisé, code 0" connexion_premier
    ok "Erreur puis bon mot de passe : « il reste 2 » puis accès autorisé" connexion_second
    ok "Décompte des essais (il reste 2, il reste 1)"   connexion_decompte
    ok "Trois erreurs : accès bloqué, code retour 1"    connexion_bloque
    ok "Trois essais maximum (le 4e n'est pas lu)"      connexion_trois
    ;;
5)
    titre "Mission 5 — Ranger les journaux"
    ok "ranger.sh est exécutable"                       executable ranger.sh
    ok "Sans paramètre : message Usage et code retour 1" ranger_usage
    ok "Dossier inexistant : message d'erreur et code retour 1" ranger_absent
    ok "Tous les .log déplacés dans archives/ (noms avec espaces compris)" ranger_logs
    ok "Les autres fichiers ne bougent pas"             ranger_autres
    ok "Ligne « Fichiers archivés : N »"                ranger_total
    ok "Fonctionne si archives/ existe déjà"            ranger_existe
    ;;
esac

bilan
