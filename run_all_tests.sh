#!/bin/bash

################################################################################
# Script de lancement de tous les tests - EVAL01
################################################################################

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# Détection de la plateforme et vérification des dépendances
################################################################################

# Détecter le système d'exploitation
OS_TYPE=$(uname -s)

# Vérifier la disponibilité de bc (nécessaire pour les calculs avec décimales)
if ! command -v bc &> /dev/null; then
    echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                    ERREUR DE DÉPENDANCE                        ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}Le programme 'bc' n'est pas installé.${NC}"
    echo ""
    if [[ "$OS_TYPE" == "Linux" ]]; then
        echo "Pour l'installer sur Ubuntu/Debian :"
        echo "  sudo apt-get update && sudo apt-get install -y bc"
        echo ""
        echo "Pour l'installer sur Fedora/RHEL :"
        echo "  sudo dnf install -y bc"
    elif [[ "$OS_TYPE" == "Darwin" ]]; then
        echo "Pour l'installer sur macOS :"
        echo "  brew install bc"
    fi
    echo ""
    exit 1
fi

# Déterminer le type de grep (GNU ou BSD)
GREP_TYPE="gnu"
if ! grep -P "test" <<< "test" &> /dev/null; then
    GREP_TYPE="bsd"
fi

# Fonction d'extraction de score compatible multi-plateforme
extract_score() {
    local file="$1"
    if [[ "$GREP_TYPE" == "gnu" ]]; then
        # GNU grep supporte -P (Perl regex)
        grep -oP "Score.*: \K[0-9.]+" "$file" 2>/dev/null | head -1
    else
        # BSD grep utilise -E (Extended regex)
        grep -oE "Score.*: [0-9.]+" "$file" 2>/dev/null | grep -oE "[0-9.]+" | head -1
    fi
}

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    EVAL01 - Tests automatisés                  ║"
echo "║       Scripts Bash - Bases et manipulation de données          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${BLUE}Plateforme détectée : $OS_TYPE (grep: $GREP_TYPE)${NC}"
echo ""

TOTAL_SCORE=0
TOTAL_MAX=24  # 5 + 5 + 6 + 8 (+ 4 bonus)

################################################################################
# Exo 1
################################################################################
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Exercice 1 : Calculatrice simple (5 pts)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if [ -f "Exos/ex1/test_ex1.sh" ]; then
    cd Exos/ex1
    chmod +x test_ex1.sh 2>/dev/null
    ./test_ex1.sh > /tmp/test_ex1_output.log 2>&1

    # Extraire le score (compatible multi-plateforme)
    SCORE_EX1=$(extract_score /tmp/test_ex1_output.log)
    cat /tmp/test_ex1_output.log

    if [ -n "$SCORE_EX1" ]; then
        TOTAL_SCORE=$(echo "$TOTAL_SCORE + $SCORE_EX1" | bc)
    fi

    cd ../..
else
    echo -e "${RED}❌ Test non disponible${NC}"
fi

echo ""
sleep 1

################################################################################
# Exo 2
################################################################################
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Exercice 2 : Vérificateur mot de passe (5 pts)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if [ -f "Exos/ex2/test_ex2.sh" ]; then
    cd Exos/ex2
    chmod +x test_ex2.sh 2>/dev/null
    ./test_ex2.sh > /tmp/test_ex2_output.log 2>&1

    # Extraire le score (compatible multi-plateforme)
    SCORE_EX2=$(extract_score /tmp/test_ex2_output.log)
    cat /tmp/test_ex2_output.log

    if [ -n "$SCORE_EX2" ]; then
        TOTAL_SCORE=$(echo "$TOTAL_SCORE + $SCORE_EX2" | bc)
    fi

    cd ../..
else
    echo -e "${RED}❌ Test non disponible${NC}"
fi

echo ""
sleep 1

################################################################################
# Exo 3
################################################################################
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Exercice 3 : Analyseur de logs (6 pts)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if [ -f "Exos/ex3/test_ex3.sh" ]; then
    cd Exos/ex3
    chmod +x test_ex3.sh 2>/dev/null
    ./test_ex3.sh > /tmp/test_ex3_output.log 2>&1

    # Extraire le score (compatible multi-plateforme)
    SCORE_EX3=$(extract_score /tmp/test_ex3_output.log)
    cat /tmp/test_ex3_output.log

    if [ -n "$SCORE_EX3" ]; then
        TOTAL_SCORE=$(echo "$TOTAL_SCORE + $SCORE_EX3" | bc)
    fi

    cd ../..
else
    echo -e "${RED}❌ Test non disponible${NC}"
fi

echo ""
sleep 1

################################################################################
# Exo 4
################################################################################
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Exercice 4 : Menu interactif (8 pts)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if [ -f "Exos/ex4/test_ex4.sh" ]; then
    cd Exos/ex4
    chmod +x test_ex4.sh 2>/dev/null
    ./test_ex4.sh > /tmp/test_ex4_output.log 2>&1

    # Extraire le score (compatible multi-plateforme)
    SCORE_EX4=$(extract_score /tmp/test_ex4_output.log)
    cat /tmp/test_ex4_output.log

    if [ -n "$SCORE_EX4" ]; then
        TOTAL_SCORE=$(echo "$TOTAL_SCORE + $SCORE_EX4" | bc)
    fi

    cd ../..
else
    echo -e "${RED}❌ Test non disponible${NC}"
fi

echo ""
sleep 1

################################################################################
# Exo 5 BONUS
################################################################################
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Exercice 5 BONUS : Compteur fichiers (4 pts)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if [ -f "Exos/ex5/test_ex5.sh" ]; then
    cd Exos/ex5
    chmod +x test_ex5.sh 2>/dev/null
    ./test_ex5.sh > /tmp/test_ex5_output.log 2>&1

    # Extraire le score (compatible multi-plateforme)
    SCORE_EX5=$(extract_score /tmp/test_ex5_output.log)
    cat /tmp/test_ex5_output.log

    if [ -n "$SCORE_EX5" ]; then
        TOTAL_SCORE=$(echo "$TOTAL_SCORE + $SCORE_EX5" | bc)
    fi

    cd ../..
else
    echo -e "${YELLOW}⚠️  Exercice bonus non tenté${NC}"
fi

echo ""

################################################################################
# Résumé final
################################################################################
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                      RÉSUMÉ GLOBAL                             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Note : Le barème total est sur 26 pts (24 exercices + 2 qualité code)
# Les tests automatiques donnent le score sur 24 pts
# L'enseignant ajoute 0-2 pts pour la qualité du code manuellement

echo "┌────────────────────────────────────────────────────────────┐"
echo "│ Exercice 1 : ${SCORE_EX1:-0} / 5 pts                                  │"
echo "│ Exercice 2 : ${SCORE_EX2:-0} / 5 pts                                  │"
echo "│ Exercice 3 : ${SCORE_EX3:-0} / 6 pts                                  │"
echo "│ Exercice 4 : ${SCORE_EX4:-0} / 8 pts                                  │"
echo "│ Exercice 5 : ${SCORE_EX5:-0} / 4 pts (BONUS)                          │"
echo "├────────────────────────────────────────────────────────────┤"
printf "│ %-56s │\n" "SCORE TESTS AUTO : $TOTAL_SCORE / 24 pts"
echo "│                                                            │"
echo "│ ⚠️  Barème complet = 26 pts (24 + 2 qualité code)          │"
echo "│ Note finale = (Score total / 26) × 20                     │"
echo "│                                                            │"
echo "│ L'enseignant ajoutera manuellement 0-2 pts pour :         │"
echo "│   • Commentaires (0.5 pt)                                 │"
echo "│   • Bonnes pratiques (0.5 pt)                             │"
echo "│   • Lisibilité (0.5 pt)                                   │"
echo "│   • Originalité (0.5 pt)                                  │"
echo "└────────────────────────────────────────────────────────────┘"
echo ""

# Affichage coloré selon le score (sur 24 pour les tests auto)
PERCENTAGE=$(echo "scale=0; $TOTAL_SCORE * 100 / 24" | bc)

if [ "$PERCENTAGE" -ge 80 ]; then
    echo -e "${GREEN}🎉 Excellent travail ! ($PERCENTAGE%)${NC}"
elif [ "$PERCENTAGE" -ge 60 ]; then
    echo -e "${YELLOW}👍 Bon travail ! ($PERCENTAGE%)${NC}"
elif [ "$PERCENTAGE" -ge 40 ]; then
    echo -e "${YELLOW}⚠️  Travail moyen, des améliorations sont nécessaires. ($PERCENTAGE%)${NC}"
else
    echo -e "${RED}⚠️  Travail insuffisant, beaucoup d'améliorations nécessaires. ($PERCENTAGE%)${NC}"
fi

echo ""

# Nettoyage
rm -f /tmp/test_ex*_output.log

exit 0
