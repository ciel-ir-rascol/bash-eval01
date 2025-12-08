#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./analyser_logs.sh"
LOGFILE="test_logs/app.log"
SCORE=0; MAX=6

echo "=========================================="
echo "Test Ex3 : Analyseur de logs"
echo "=========================================="
echo ""

[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
[ ! -f "$LOGFILE" ] && echo -e "${RED}❌ Fichier log inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Test 1: Vérification paramètre et fichier (1pt)
$SCRIPT > /dev/null 2>&1 && echo -e "${RED}✗ Devrait échouer sans paramètre${NC}" || { echo -e "${GREEN}✓ Vérification paramètre OK${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); }
$SCRIPT "/inexistant" > /dev/null 2>&1 && echo -e "${RED}✗ Devrait échouer fichier inexistant${NC}" || { echo -e "${GREEN}✓ Vérification fichier OK${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); }

OUTPUT=$($SCRIPT "$LOGFILE" 2>&1)

# Test 2: Comptage total lignes (0.5pt)
echo "$OUTPUT" | grep -qE "([Tt]otal|lignes).*8" && { echo -e "${GREEN}✓ Total lignes correct (8)${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Total lignes incorrect${NC}"

# Test 3: Comptage INFO (0.5pt)
echo "$OUTPUT" | grep -iE "INFO.*4" && { echo -e "${GREEN}✓ INFO correct (4)${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ INFO incorrect${NC}"

# Test 4: Comptage WARNING (0.5pt)
echo "$OUTPUT" | grep -iE "WARNING.*2" && { echo -e "${GREEN}✓ WARNING correct (2)${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ WARNING incorrect${NC}"

# Test 5: Comptage ERROR (0.5pt)
echo "$OUTPUT" | grep -iE "ERROR.*2" && { echo -e "${GREEN}✓ ERROR correct (2)${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ ERROR incorrect${NC}"

# Test 6: Taux d'erreurs (1.5pt)
echo "$OUTPUT" | grep -qE "25|taux.*25" && { echo -e "${GREEN}✓ Taux d'erreurs correct (25%)${NC}"; SCORE=$(echo "$SCORE + 1.5" | bc); } || echo -e "${RED}✗ Taux d'erreurs incorrect${NC}"

# Test 7: Dernière erreur (1.5pt)
echo "$OUTPUT" | grep -q "config.json" && { echo -e "${GREEN}✓ Dernière erreur affichée${NC}"; SCORE=$(echo "$SCORE + 1.5" | bc); } || echo -e "${RED}✗ Dernière erreur non affichée${NC}"

echo ""; echo "Score : $SCORE / $MAX"

# Retourner un code d'erreur si le score n'est pas parfait (pour GitHub Classroom)
if (( $(echo "$SCORE < $MAX" | bc -l) )); then
    exit 1
else
    exit 0
fi
