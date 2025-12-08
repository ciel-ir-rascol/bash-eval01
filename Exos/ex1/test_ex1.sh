#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./calculatrice.sh"
MAX=7

# Note: bc n'est plus nécessaire pour le script de test (scores entiers)
# mais reste requis pour le script étudiant (calculatrice.sh)

# Vérifier l'existence du script
[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Fonction pour exécuter un test individuel
run_test() {
    local test_num=$1
    case $test_num in
        1)
            # Test 1: Vérification paramètres (1pt)
            $SCRIPT > /dev/null 2>&1 && { echo -e "${RED}✗ Test 1 (1pt): Devrait échouer sans paramètres${NC}"; return 1; } || { echo -e "${GREEN}✓ Test 1 (1pt): Vérification paramètres OK${NC}"; return 0; }
            ;;
        2)
            # Test 2: Addition (1pt)
            RESULT=$($SCRIPT 10 + 5 2>&1 | grep -oE "[0-9]+$" | tail -1)
            [ "$RESULT" = "15" ] && { echo -e "${GREEN}✓ Test 2 (1pt): Addition 10+5=15${NC}"; return 0; } || { echo -e "${RED}✗ Test 2 (1pt): Addition incorrecte${NC}"; return 1; }
            ;;
        3)
            # Test 3: Soustraction (1pt)
            RESULT=$($SCRIPT 20 - 8 2>&1 | grep -oE "[0-9]+$" | tail -1)
            [ "$RESULT" = "12" ] && { echo -e "${GREEN}✓ Test 3 (1pt): Soustraction 20-8=12${NC}"; return 0; } || { echo -e "${RED}✗ Test 3 (1pt): Soustraction incorrecte${NC}"; return 1; }
            ;;
        4)
            # Test 4: Multiplication (1pt)
            RESULT=$($SCRIPT 6 '*' 7 2>&1 | grep -oE "[0-9]+$" | tail -1)
            [ "$RESULT" = "42" ] && { echo -e "${GREEN}✓ Test 4 (1pt): Multiplication 6*7=42${NC}"; return 0; } || { echo -e "${RED}✗ Test 4 (1pt): Multiplication incorrecte${NC}"; return 1; }
            ;;
        5)
            # Test 5: Division (1pt)
            RESULT=$($SCRIPT 15 / 3 2>&1 | grep -oE "[0-9]+$" | tail -1)
            [ "$RESULT" = "5" ] && { echo -e "${GREEN}✓ Test 5 (1pt): Division 15/3=5${NC}"; return 0; } || { echo -e "${RED}✗ Test 5 (1pt): Division incorrecte${NC}"; return 1; }
            ;;
        6)
            # Test 6: Division par zéro (1pt)
            $SCRIPT 10 / 0 2>&1 | grep -iq "zéro\|zero\|impossible" && { echo -e "${GREEN}✓ Test 6 (1pt): Division par zéro gérée${NC}"; return 0; } || { echo -e "${RED}✗ Test 6 (1pt): Division par zéro non gérée${NC}"; return 1; }
            ;;
        7)
            # Test 7: Opérateur invalide (1pt)
            $SCRIPT 10 % 3 > /dev/null 2>&1 && { echo -e "${RED}✗ Test 7 (1pt): Opérateur invalide non détecté${NC}"; return 1; } || { echo -e "${GREEN}✓ Test 7 (1pt): Opérateur invalide détecté${NC}"; return 0; }
            ;;
        *)
            echo -e "${RED}✗ Numéro de test invalide: $test_num${NC}"
            return 1
            ;;
    esac
}

# Si un argument est fourni, exécuter uniquement ce test
if [ $# -eq 1 ]; then
    TEST_NUM=$1
    if ! [[ "$TEST_NUM" =~ ^[0-9]+$ ]] || [ "$TEST_NUM" -lt 1 ] || [ "$TEST_NUM" -gt $MAX ]; then
        echo -e "${RED}Erreur: Le numéro de test doit être entre 1 et $MAX${NC}"
        exit 1
    fi
    run_test $TEST_NUM
    exit $?
fi

# Sinon, exécuter tous les tests
echo "=========================================="
echo "Test Ex1 : Calculatrice simple"
echo "=========================================="
echo ""

SCORE=0
for i in $(seq 1 $MAX); do
    if run_test $i; then
        SCORE=$((SCORE + 1))
    fi
done

echo ""
echo "Score : $SCORE / $MAX"

# Retourner un code d'erreur si le score n'est pas parfait
[ $SCORE -eq $MAX ] && exit 0 || exit 1
