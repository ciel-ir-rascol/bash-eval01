#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./menu_calculs.sh"
SCORE=0; MAX=8

echo "=========================================="
echo "Test Ex4 : Menu interactif"
echo "=========================================="
echo ""

[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Vérifier la présence de structures clés dans le code
echo "Analyse du code..."

# Test 1: Lecture des nombres (1pt)
grep -qE "read.*-a|read.*nombres" "$SCRIPT" && { echo -e "${GREEN}✓ Lecture tableau détectée${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Lecture tableau non détectée${NC}"

# Test 2: Structure case (1.5pt)
grep -qiE "case.*in" "$SCRIPT" && { echo -e "${GREEN}✓ Structure case détectée${NC}"; SCORE=$(echo "$SCORE + 1.5" | bc); } || echo -e "${RED}✗ Structure case non détectée${NC}"

# Test 3: Calcul somme (1pt)
grep -qiE "somme.*for|for.*somme|calculer_somme" "$SCRIPT" && { echo -e "${GREEN}✓ Calcul somme détecté${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Calcul somme non détecté${NC}"

# Test 4: Calcul moyenne (1.5pt)
grep -qiE "moyenne|somme.*\/" "$SCRIPT" && { echo -e "${GREEN}✓ Calcul moyenne détecté${NC}"; SCORE=$(echo "$SCORE + 1.5" | bc); } || echo -e "${RED}✗ Calcul moyenne non détecté${NC}"

# Test 5: Recherche min (1.5pt)
grep -qiE "min|minimum" "$SCRIPT" && { echo -e "${GREEN}✓ Recherche minimum détectée${NC}"; SCORE=$(echo "$SCORE + 1.5" | bc); } || echo -e "${RED}✗ Recherche minimum non détectée${NC}"

# Test 6: Recherche max (1pt)
grep -qiE "max|maximum" "$SCRIPT" && { echo -e "${GREEN}✓ Recherche maximum détectée${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Recherche maximum non détectée${NC}"

# Test 7: Boucle (0.5pt)
grep -qiE "while.*true|while.*1|done" "$SCRIPT" && { echo -e "${GREEN}✓ Boucle détectée${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Boucle non détectée${NC}"

echo ""
echo "⚠️  Note: Tests basiques (analyse de code). Test manuel recommandé."
echo "Score : $SCORE / $MAX"

# Retourner un code d'erreur si le score n'est pas parfait (pour GitHub Classroom)
if (( $(echo "$SCORE < $MAX" | bc -l) )); then
    exit 1
else
    exit 0
fi
