#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./analyser_logs.sh"
LOGFILE="test_logs/app.log"
MAX=8

# Note: bc n'est plus nécessaire pour le script de test (scores entiers)

# Vérifier l'existence du script et du fichier log
[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
[ ! -f "$LOGFILE" ] && echo -e "${RED}❌ Fichier log inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Fonction pour exécuter un test individuel
run_test() {
    local test_num=$1
    case $test_num in
        1)
            # Test 1: Vérification paramètre (1pt)
            $SCRIPT > /dev/null 2>&1 && { echo -e "${RED}✗ Test 1: Devrait échouer sans paramètre${NC}"; return 1; } || { echo -e "${GREEN}✓ Test 1: Vérification paramètre OK${NC}"; return 0; }
            ;;
        2)
            # Test 2: Vérification fichier inexistant (1pt)
            $SCRIPT "/inexistant" > /dev/null 2>&1 && { echo -e "${RED}✗ Test 2: Devrait échouer fichier inexistant${NC}"; return 1; } || { echo -e "${GREEN}✓ Test 2: Vérification fichier OK${NC}"; return 0; }
            ;;
        3)
            # Test 3: Total lignes correct (1pt)
            OUTPUT=$($SCRIPT "$LOGFILE" 2>&1)
            echo "$OUTPUT" | grep -qE "([Tt]otal|lignes).*8" && { echo -e "${GREEN}✓ Test 3: Total lignes correct (8)${NC}"; return 0; } || { echo -e "${RED}✗ Test 3: Total lignes incorrect${NC}"; return 1; }
            ;;
        4)
            # Test 4: Comptage INFO (1pt)
            OUTPUT=$($SCRIPT "$LOGFILE" 2>&1)
            echo "$OUTPUT" | grep -iE "INFO.*4" && { echo -e "${GREEN}✓ Test 4: INFO correct (4)${NC}"; return 0; } || { echo -e "${RED}✗ Test 4: INFO incorrect${NC}"; return 1; }
            ;;
        5)
            # Test 5: Comptage WARNING (1pt)
            OUTPUT=$($SCRIPT "$LOGFILE" 2>&1)
            echo "$OUTPUT" | grep -iE "WARNING.*2" && { echo -e "${GREEN}✓ Test 5: WARNING correct (2)${NC}"; return 0; } || { echo -e "${RED}✗ Test 5: WARNING incorrect${NC}"; return 1; }
            ;;
        6)
            # Test 6: Comptage ERROR (1pt)
            OUTPUT=$($SCRIPT "$LOGFILE" 2>&1)
            echo "$OUTPUT" | grep -iE "ERROR.*2" && { echo -e "${GREEN}✓ Test 6: ERROR correct (2)${NC}"; return 0; } || { echo -e "${RED}✗ Test 6: ERROR incorrect${NC}"; return 1; }
            ;;
        7)
            # Test 7: Taux d'erreurs (2pts)
            OUTPUT=$($SCRIPT "$LOGFILE" 2>&1)
            echo "$OUTPUT" | grep -qE "25|taux.*25" && { echo -e "${GREEN}✓ Test 7: Taux d'erreurs correct (25%)${NC}"; return 0; } || { echo -e "${RED}✗ Test 7: Taux d'erreurs incorrect${NC}"; return 1; }
            ;;
        8)
            # Test 8: Dernière erreur affichée (1pt)
            OUTPUT=$($SCRIPT "$LOGFILE" 2>&1)
            echo "$OUTPUT" | grep -q "config.json" && { echo -e "${GREEN}✓ Test 8: Dernière erreur affichée${NC}"; return 0; } || { echo -e "${RED}✗ Test 8: Dernière erreur non affichée${NC}"; return 1; }
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
echo "Test Ex3 : Analyseur de logs"
echo "=========================================="
echo ""

SCORE=0
for i in $(seq 1 $MAX); do
    if run_test $i; then
        if [ $i -eq 7 ]; then
            # Le test 7 vaut 2 points
            SCORE=$((SCORE + 2))
        else
            SCORE=$((SCORE + 1))
        fi
    fi
done

echo ""
echo "Score : $SCORE / 9"

# Retourner un code d'erreur si le score n'est pas parfait
[ $SCORE -eq 9 ] && exit 0 || exit 1
