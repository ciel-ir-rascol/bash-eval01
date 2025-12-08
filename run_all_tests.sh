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
TOTAL_MAX=36  # 7 + 8 + 9 + 12 (+ 5 bonus)

################################################################################
# Exo 1
################################################################################
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Exercice 1 : Calculatrice simple (7 pts)${NC}"
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
echo -e "${BLUE}Exercice 2 : Vérificateur mot de passe (8 pts)${NC}"
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
echo -e "${BLUE}Exercice 3 : Analyseur de logs (9 pts)${NC}"
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
echo -e "${BLUE}Exercice 4 : Menu interactif (12 pts)${NC}"
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
echo -e "${BLUE}Exercice 5 BONUS : Compteur fichiers (5 pts)${NC}"
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

# Note : Le barème total est sur 36 pts obligatoires (sans bonus)
# Les tests automatiques donnent le score sur 36 pts
# Le bonus peut ajouter jusqu'à 5 pts supplémentaires

echo "┌────────────────────────────────────────────────────────────┐"
echo "│ Exercice 1 : ${SCORE_EX1:-0} / 7 pts   (7 tests × 1pt)                │"
echo "│ Exercice 2 : ${SCORE_EX2:-0} / 8 pts   (8 tests × 1pt)                │"
echo "│ Exercice 3 : ${SCORE_EX3:-0} / 9 pts   (7 tests × 1pt + 1 test × 2pts)│"
echo "│ Exercice 4 : ${SCORE_EX4:-0} / 12 pts  (4 tests × 3pts)               │"
echo "│ Exercice 5 : ${SCORE_EX5:-0} / 5 pts   (5 tests × 1pt - BONUS)        │"
echo "├────────────────────────────────────────────────────────────┤"
printf "│ %-56s │\n" "SCORE TESTS AUTO : $TOTAL_SCORE / 36 pts"
echo "│                                                            │"
echo "│ ⚠️  Barème complet = 36 pts obligatoires + 5 pts bonus     │"
echo "│ Note finale = (Score / 36) × 20                           │"
echo "│ Note avec bonus = min(20, (Score / 36) × 20)             │"
echo "└────────────────────────────────────────────────────────────┘"
echo ""

# Affichage coloré selon le score (sur 36 pour les tests auto)
PERCENTAGE=$(echo "scale=0; $TOTAL_SCORE * 100 / 36" | bc)

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
