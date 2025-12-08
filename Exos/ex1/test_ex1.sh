#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./calculatrice.sh"
SCORE=0; MAX=5

echo "=========================================="
echo "Test Ex1 : Calculatrice simple"
echo "=========================================="
echo ""

[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Test 1: Vérification paramètres (1pt)
$SCRIPT > /dev/null 2>&1 && echo -e "${RED}✗ Devrait échouer sans paramètres${NC}" || { echo -e "${GREEN}✓ Vérification paramètres OK${NC}"; SCORE=$(echo "$SCORE + 1" | bc); }

# Test 2: Addition (0.5pt)
RESULT=$($SCRIPT 10 + 5 2>&1 | grep -oE "[0-9]+" | tail -1)
[ "$RESULT" = "15" ] && { echo -e "${GREEN}✓ Addition: 10+5=15${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Addition incorrecte${NC}"

# Test 3: Soustraction (0.5pt)
RESULT=$($SCRIPT 20 - 8 2>&1 | grep -oE "[0-9]+" | tail -1)
[ "$RESULT" = "12" ] && { echo -e "${GREEN}✓ Soustraction: 20-8=12${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Soustraction incorrecte${NC}"

# Test 4: Multiplication (0.5pt)
RESULT=$($SCRIPT 6 '*' 7 2>&1 | grep -oE "[0-9]+" | tail -1)
[ "$RESULT" = "42" ] && { echo -e "${GREEN}✓ Multiplication: 6*7=42${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Multiplication incorrecte${NC}"

# Test 5: Division (0.5pt)
RESULT=$($SCRIPT 15 / 3 2>&1 | grep -oE "[0-9]+" | tail -1)
[ "$RESULT" = "5" ] && { echo -e "${GREEN}✓ Division: 15/3=5${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Division incorrecte${NC}"

# Test 6: Division par zéro (1pt)
$SCRIPT 10 / 0 2>&1 | grep -iq "zéro\|zero\|impossible" && { echo -e "${GREEN}✓ Division par zéro gérée${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Division par zéro non gérée${NC}"

# Test 7: Opérateur invalide (1pt)
$SCRIPT 10 % 3 > /dev/null 2>&1 && echo -e "${RED}✗ Opérateur invalide non détecté${NC}" || { echo -e "${GREEN}✓ Opérateur invalide détecté${NC}"; SCORE=$(echo "$SCORE + 1" | bc); }

echo ""; echo "Score : $SCORE / $MAX"

# Retourner un code d'erreur si le score n'est pas parfait (pour GitHub Classroom)
if (( $(echo "$SCORE < $MAX" | bc -l) )); then
    exit 1
else
    exit 0
fi
