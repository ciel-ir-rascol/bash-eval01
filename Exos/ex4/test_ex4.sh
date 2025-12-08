#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./menu_calculs.sh"
SCORE=0; MAX=8

# Vérifier la disponibilité de bc
if ! command -v bc &> /dev/null; then
    echo "ERREUR: La commande 'bc' n'est pas installée."
    echo "Installation: sudo apt-get install -y bc"
    exit 1
fi

echo "=========================================="
echo "Test Ex4 : Menu interactif"
echo "=========================================="
echo ""

[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Fonction helper pour tester le menu avec des entrées simulées
test_menu() {
    local numbers="$1"
    local choice="$2"
    local expected_output="$3"
    local test_name="$4"

    # Simuler les entrées : liste de nombres + choix du menu + 5 (quitter)
    # Utiliser timeout si disponible (Linux/Ubuntu), sinon exécuter directement (macOS)
    if command -v timeout &> /dev/null; then
        # Sur Ubuntu/Linux, utiliser timeout pour éviter les boucles infinies
        OUTPUT=$(echo -e "$numbers\n$choice\n5" | timeout 5 "$SCRIPT" 2>&1)
        local exit_code=$?
        # Si timeout (code 124), le script n'a pas quitté proprement
        if [ $exit_code -eq 124 ]; then
            OUTPUT="ERREUR: Le script n'a pas quitté dans les 5 secondes (boucle infinie ?)"
            return 1
        fi
    else
        # Sur macOS, pas de timeout disponible par défaut
        OUTPUT=$(echo -e "$numbers\n$choice\n5" | "$SCRIPT" 2>&1)
    fi

    if echo "$OUTPUT" | grep -iq "$expected_output"; then
        echo -e "${GREEN}✓ $test_name${NC}"
        return 0
    else
        echo -e "${RED}✗ $test_name${NC}"
        echo "  Attendu: pattern '$expected_output'"
        echo "  Sortie obtenue:"
        echo "$OUTPUT" | tail -30
        return 1
    fi
}

# Test 1: Somme (2 pts)
echo "Test de la somme..."
if test_menu "5 10 15" "1" "somme.*30\|30" "Somme de 5+10+15=30"; then
    SCORE=$(echo "$SCORE + 2" | bc)
fi

# Test 2: Moyenne (2 pts)
echo "Test de la moyenne..."
if test_menu "10 20 30 40" "2" "moyenne.*25\|25" "Moyenne de 10,20,30,40=25"; then
    SCORE=$(echo "$SCORE + 2" | bc)
fi

# Test 3: Minimum (2 pts)
echo "Test du minimum..."
if test_menu "15 3 8 20" "3" "minimum.*3\|3" "Minimum de 15,3,8,20=3"; then
    SCORE=$(echo "$SCORE + 2" | bc)
fi

# Test 4: Maximum (2 pts)
echo "Test du maximum..."
if test_menu "7 25 12 8" "4" "maximum.*25\|25" "Maximum de 7,25,12,8=25"; then
    SCORE=$(echo "$SCORE + 2" | bc)
fi

# Tests bonus (analyse de code statique)
echo ""
echo "Vérifications supplémentaires..."

# Vérifier la présence de structures importantes
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
echo "Score : $SCORE / $MAX"

# Retourner un code d'erreur si le score n'est pas parfait (pour GitHub Classroom)
if (( $(echo "$SCORE < $MAX" | bc -l) )); then
    exit 1
else
    exit 0
fi
