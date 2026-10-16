#!/bin/bash
#
# preparer.sh — Prepare le dossier de travail de l'evaluation Bash (bash-eval01)
# A executer SUR LE POSTE, en utilisateur normal (pas de sudo), UNE SEULE FOIS :
#     ~/bash-eval01/scripts/preparer.sh
#
# Cree outils/ DANS le depot clone (rien n'est ecrit ailleurs) : les 5 scripts
# a completer (non executables) et un dossier d'exemple « captures » pour
# essayer la mission 5.
#
# Pour recreer uniquement le dossier d'exemple (apres des essais) :
#     ~/bash-eval01/scripts/preparer.sh --captures
#

# Racine du depot clone : le dossier parent de scripts/
DEPOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTILS="$DEPOT/outils"

if [ "$(id -u)" -eq 0 ]; then
    echo "Ne lancez pas ce script avec sudo : relancez-le en utilisateur normal." >&2
    exit 1
fi

# Dossier d'exemple pour la mission 5 (le script de verification utilise le sien)
creer_captures() {
    local d="$OUTILS/captures"
    rm -rf "$d"
    mkdir -p "$d"
    echo "64 bytes from 10.116.0.254: icmp_seq=1 ttl=64 time=0.41 ms" > "$d/ping-passerelle.log"
    echo "64 bytes from 10.116.0.53: icmp_seq=1 ttl=64 time=0.38 ms"  > "$d/ping-dns.log"
    echo "12:04:51 ARP, Request who-has 10.116.0.254 tell 10.116.0.101" > "$d/capture wifi.log"
    echo "Vérifier le câblage des postes 07 à 10"                        > "$d/notes.txt"
    echo "Schéma de la baie (image)"                                     > "$d/schema.png"
    echo "Compte rendu de l'intervention du lundi"                       > "$d/rapport final.txt"
}

if [ "$1" = "--captures" ]; then
    if [ ! -f "$OUTILS/.eval-bash" ]; then
        echo "$OUTILS n'a pas encore été préparé : lancez ce script sans option." >&2
        exit 1
    fi
    creer_captures
    echo "Dossier d'exemple recréé : $OUTILS/captures"
    exit 0
fi

if [ -e "$OUTILS" ]; then
    echo "$OUTILS existe déjà : le dossier a déjà été préparé." >&2
    echo "Pour recréer seulement le dossier d'exemple de la mission 5 :" >&2
    echo "    $0 --captures" >&2
    exit 1
fi

mkdir -p "$OUTILS" || exit 1

# squelette <fichier> <mission> <rôle> <utilisation> [ligne de code fournie]
squelette() {
    {
        echo "#!/bin/bash"
        echo "#"
        echo "# $1 — Mission $2 : $3"
        echo "# Utilisation : $4"
        echo "# Auteur : $USER"
        echo "#"
        echo
        [ -n "$5" ] && { echo "$5"; echo; }
        echo "# Votre code ici"
    } > "$OUTILS/$1"
    chmod -x "$OUTILS/$1"
}

squelette bienvenue.sh 1 "message de bienvenue"         "./bienvenue.sh"
squelette adresse.sh   2 "adresse IP d'un poste"        "./adresse.sh NUMERO"
squelette plan.sh      3 "plan d'adressage de la salle" "./plan.sh NOMBRE"
squelette connexion.sh 4 "connexion par mot de passe"   "./connexion.sh" \
    'MOT_DE_PASSE="Rascol81"    # mot de passe attendu (ne pas modifier)'
squelette ranger.sh    5 "archivage des journaux .log"  "./ranger.sh DOSSIER"

creer_captures
touch "$OUTILS/.eval-bash"

echo "Dossier préparé : $OUTILS"
echo "Placez-vous dedans pour commencer :"
echo "    cd $OUTILS"
