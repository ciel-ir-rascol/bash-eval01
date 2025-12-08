#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./menu_calculs.sh"
MAX=4

# Note: bc n'est plus nécessaire pour le script de test (scores entiers)

# Vérifier l'existence du script
[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Fonction helper pour tester le menu avec des entrées simulées
test_menu() {
    local numbers="$1"
    local choice="$2"
    local expected_output="$3"

    # Simuler les entrées : liste de nombres + choix du menu + 5 (quitter)
    # Utiliser timeout si disponible (Linux/Ubuntu), sinon exécuter directement (macOS)
    if command -v timeout &> /dev/null; then
        # Sur Ubuntu/Linux, utiliser timeout pour éviter les boucles infinies
        OUTPUT=$(echo -e "$numbers\n$choice\n5" | timeout 5 "$SCRIPT" 2>&1)
        local exit_code=$?
        # Si timeout (code 124), le script n'a pas quitté proprement
        if [ $exit_code -eq 124 ]; then
            return 1
        fi
    else
        # Sur macOS, pas de timeout disponible par défaut
        OUTPUT=$(echo -e "$numbers\n$choice\n5" | "$SCRIPT" 2>&1)
    fi

    echo "$OUTPUT" | grep -iq "$expected_output" && return 0 || return 1
}

# Fonction pour exécuter un test individuel
run_test() {
    local test_num=$1
    case $test_num in
        1)
            # Test 1: Somme (3pts)
            if test_menu "5 10 15" "1" "somme.*30\|30"; then
                echo -e "${GREEN}✓ Test 1 (3pts): Somme 5+10+15=30${NC}"
                return 0
            else
                echo -e "${RED}✗ Test 1 (3pts): Somme incorrecte${NC}"
                return 1
            fi
            ;;
        2)
            # Test 2: Moyenne (3pts)
            if test_menu "10 20 30 40" "2" "moyenne.*25\|25"; then
                echo -e "${GREEN}✓ Test 2 (3pts): Moyenne 10,20,30,40=25${NC}"
                return 0
            else
                echo -e "${RED}✗ Test 2 (3pts): Moyenne incorrecte${NC}"
                return 1
            fi
            ;;
        3)
            # Test 3: Minimum (3pts)
            if test_menu "15 3 8 20" "3" "minimum.*3\|3"; then
                echo -e "${GREEN}✓ Test 3 (3pts): Minimum 15,3,8,20=3${NC}"
                return 0
            else
                echo -e "${RED}✗ Test 3 (3pts): Minimum incorrect${NC}"
                return 1
            fi
            ;;
        4)
            # Test 4: Maximum (3pts)
            if test_menu "7 25 12 8" "4" "maximum.*25\|25"; then
                echo -e "${GREEN}✓ Test 4 (3pts): Maximum 7,25,12,8=25${NC}"
                return 0
            else
                echo -e "${RED}✗ Test 4 (3pts): Maximum incorrect${NC}"
                return 1
            fi
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
echo "Test Ex4 : Menu interactif"
echo "=========================================="
echo ""

SCORE=0
for i in $(seq 1 $MAX); do
    if run_test $i; then
        # Chaque test vaut 3 points
        SCORE=$((SCORE + 3))
    fi
done

echo ""
echo "Vérifications supplémentaires..."

# Tests bonus (analyse de code statique - non comptabilisés)
if grep -qE "read.*-a|read -p.*nombres" "$SCRIPT"; then
    echo -e "${GREEN}✓ Lecture tableau détectée${NC}"
else
    echo -e "${RED}⚠ Lecture tableau non détectée (pas de malus)${NC}"
fi

if grep -qiE "case.*in" "$SCRIPT"; then
    echo -e "${GREEN}✓ Structure case détectée${NC}"
else
    echo -e "${RED}⚠ Structure case non détectée (pas de malus)${NC}"
fi

if grep -qiE "while.*true|while.*1|until|for.*menu" "$SCRIPT"; then
    echo -e "${GREEN}✓ Boucle de menu détectée${NC}"
else
    echo -e "${RED}⚠ Boucle de menu non détectée (pas de malus)${NC}"
fi

echo ""
echo "Score : $SCORE / 12"

# Retourner un code d'erreur si le score n'est pas parfait
[ $SCORE -eq 12 ] && exit 0 || exit 1
