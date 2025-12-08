#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./compteur_fichiers.sh"
TEST_DIR="/tmp/test_compteur_$$"
MAX=5

# Note: bc n'est plus nécessaire pour le script de test (scores entiers)

# Vérifier l'existence du script
[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Fonction pour créer l'environnement de test
setup_test_env() {
    rm -rf "$TEST_DIR"
    mkdir -p "$TEST_DIR/subdir"
    touch "$TEST_DIR/file1.txt" "$TEST_DIR/file2.txt" "$TEST_DIR/file3.txt"
    touch "$TEST_DIR/script1.sh" "$TEST_DIR/script2.sh"
    touch "$TEST_DIR/image.jpg"
    touch "$TEST_DIR/subdir/data.txt"
}

# Fonction pour nettoyer l'environnement de test
cleanup_test_env() {
    rm -rf "$TEST_DIR"
}

# Fonction pour exécuter un test individuel
run_test() {
    local test_num=$1
    case $test_num in
        1)
            # Test 1: Vérification paramètre (1pt)
            $SCRIPT > /dev/null 2>&1 && { echo -e "${RED}✗ Test 1: Devrait échouer sans paramètre${NC}"; return 1; } || { echo -e "${GREEN}✓ Test 1: Vérification paramètre OK${NC}"; return 0; }
            ;;
        2)
            # Test 2: Utilisation de find (1pt)
            grep -q "find" "$SCRIPT" && { echo -e "${GREEN}✓ Test 2: Commande find utilisée${NC}"; return 0; } || { echo -e "${RED}✗ Test 2: Commande find non trouvée${NC}"; return 1; }
            ;;
        3)
            # Test 3: Extraction extension (1pt)
            grep -qE "##\*\.|%\.\*|\.tar" "$SCRIPT" && { echo -e "${GREEN}✓ Test 3: Extraction extension détectée${NC}"; return 0; } || { echo -e "${RED}✗ Test 3: Extraction extension non détectée${NC}"; return 1; }
            ;;
        4)
            # Test 4: Comptage .txt (1pt)
            setup_test_env
            OUTPUT=$($SCRIPT "$TEST_DIR" 2>&1)
            cleanup_test_env
            echo "$OUTPUT" | grep -iE "\.txt.*4" && { echo -e "${GREEN}✓ Test 4: Comptage .txt correct (4)${NC}"; return 0; } || { echo -e "${RED}✗ Test 4: Comptage .txt incorrect${NC}"; return 1; }
            ;;
        5)
            # Test 5: Comptage .sh (1pt)
            setup_test_env
            OUTPUT=$($SCRIPT "$TEST_DIR" 2>&1)
            cleanup_test_env
            echo "$OUTPUT" | grep -iE "\.sh.*2" && { echo -e "${GREEN}✓ Test 5: Comptage .sh correct (2)${NC}"; return 0; } || { echo -e "${RED}✗ Test 5: Comptage .sh incorrect${NC}"; return 1; }
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
echo "Test Ex5 BONUS : Compteur fichiers"
echo "=========================================="
echo ""

SCORE=0
for i in $(seq 1 $MAX); do
    if run_test $i; then
        SCORE=$((SCORE + 1))
    fi
done

echo ""
echo "Score BONUS : $SCORE / $MAX"

# Retourner un code d'erreur si le score n'est pas parfait
[ $SCORE -eq $MAX ] && exit 0 || exit 1
