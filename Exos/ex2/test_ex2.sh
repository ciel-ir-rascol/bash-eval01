#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./verif_password.sh"
MAX=8

# Note: bc n'est plus nécessaire pour le script de test (scores entiers)

# Vérifier l'existence du script
[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Fonction pour exécuter un test individuel
run_test() {
    local test_num=$1
    case $test_num in
        1)
            # Test 1: Vérification paramètre (1pt)
            $SCRIPT > /dev/null 2>&1 && { echo -e "${RED}✗ Test 1 (1pt): Devrait échouer sans paramètre${NC}"; return 1; } || { echo -e "${GREEN}✓ Test 1 (1pt): Vérification paramètre OK${NC}"; return 0; }
            ;;
        2)
            # Test 2: Mot de passe faible détecté (1pt)
            OUTPUT=$($SCRIPT "abc" 2>&1)
            echo "$OUTPUT" | grep -qiE "faible|weak" && { echo -e "${GREEN}✓ Test 2 (1pt): Mot de passe faible détecté${NC}"; return 0; } || { echo -e "${RED}✗ Test 2 (1pt): Niveau faible non détecté${NC}"; return 1; }
            ;;
        3)
            # Test 3: Détection longueur (1pt)
            OUTPUT=$($SCRIPT "MotDePasse123!" 2>&1)
            echo "$OUTPUT" | grep -qiE "longueur|length" && { echo -e "${GREEN}✓ Test 3 (1pt): Longueur vérifiée${NC}"; return 0; } || { echo -e "${RED}✗ Test 3 (1pt): Longueur non vérifiée${NC}"; return 1; }
            ;;
        4)
            # Test 4: Détection majuscules (1pt)
            OUTPUT=$($SCRIPT "MotDePasse123!" 2>&1)
            echo "$OUTPUT" | grep -qiE "majuscule|uppercase" && { echo -e "${GREEN}✓ Test 4 (1pt): Majuscules détectées${NC}"; return 0; } || { echo -e "${RED}✗ Test 4 (1pt): Majuscules non détectées${NC}"; return 1; }
            ;;
        5)
            # Test 5: Détection minuscules (1pt)
            OUTPUT=$($SCRIPT "MotDePasse123!" 2>&1)
            echo "$OUTPUT" | grep -qiE "minuscule|lowercase" && { echo -e "${GREEN}✓ Test 5 (1pt): Minuscules détectées${NC}"; return 0; } || { echo -e "${RED}✗ Test 5 (1pt): Minuscules non détectées${NC}"; return 1; }
            ;;
        6)
            # Test 6: Détection chiffres (1pt)
            OUTPUT=$($SCRIPT "MotDePasse123!" 2>&1)
            echo "$OUTPUT" | grep -qiE "chiffre|digit|nombre" && { echo -e "${GREEN}✓ Test 6 (1pt): Chiffres détectés${NC}"; return 0; } || { echo -e "${RED}✗ Test 6 (1pt): Chiffres non détectés${NC}"; return 1; }
            ;;
        7)
            # Test 7: Détection caractères spéciaux (1pt)
            OUTPUT=$($SCRIPT "MotDePasse123!" 2>&1)
            echo "$OUTPUT" | grep -qiE "spéciau|special" && { echo -e "${GREEN}✓ Test 7 (1pt): Caractères spéciaux détectés${NC}"; return 0; } || { echo -e "${RED}✗ Test 7 (1pt): Caractères spéciaux non détectés${NC}"; return 1; }
            ;;
        8)
            # Test 8: Score/Niveau affiché (1pt)
            OUTPUT=$($SCRIPT "MotDePasse123!" 2>&1)
            echo "$OUTPUT" | grep -qiE "score|niveau|level" && { echo -e "${GREEN}✓ Test 8 (1pt): Score/Niveau affiché${NC}"; return 0; } || { echo -e "${RED}✗ Test 8 (1pt): Score/Niveau non affiché${NC}"; return 1; }
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
echo "Test Ex2 : Vérificateur mot de passe"
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
