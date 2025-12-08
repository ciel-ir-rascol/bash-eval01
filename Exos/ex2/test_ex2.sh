#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./verif_password.sh"
SCORE=0; MAX=5

echo "=========================================="
echo "Test Ex2 : Vérificateur mot de passe"
echo "=========================================="
echo ""

[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Test 1: Vérification paramètre (0.5pt)
$SCRIPT > /dev/null 2>&1 && echo -e "${RED}✗ Devrait échouer sans paramètre${NC}" || { echo -e "${GREEN}✓ Vérification paramètre OK${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); }

# Test 2: Mot de passe faible (1pt)
OUTPUT=$($SCRIPT "abc" 2>&1)
echo "$OUTPUT" | grep -qiE "faible|weak" && { echo -e "${GREEN}✓ Mot de passe faible détecté${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Niveau faible non détecté${NC}"

# Test 3: Détection longueur (0.5pt)
OUTPUT=$($SCRIPT "MotDePasse123!" 2>&1)
echo "$OUTPUT" | grep -qiE "longueur|length" && { echo -e "${GREEN}✓ Longueur vérifiée${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Longueur non vérifiée${NC}"

# Test 4: Détection majuscules/minuscules (1pt)
echo "$OUTPUT" | grep -qiE "majuscule|uppercase" && { echo -e "${GREEN}✓ Majuscules détectées${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Majuscules non détectées${NC}"
echo "$OUTPUT" | grep -qiE "minuscule|lowercase" && { echo -e "${GREEN}✓ Minuscules détectées${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Minuscules non détectées${NC}"

# Test 5: Détection chiffres (0.5pt)
echo "$OUTPUT" | grep -qiE "chiffre|digit|nombre" && { echo -e "${GREEN}✓ Chiffres détectés${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); } || echo -e "${RED}✗ Chiffres non détectés${NC}"

# Test 6: Détection caractères spéciaux (1pt)
echo "$OUTPUT" | grep -qiE "spéciau|special" && { echo -e "${GREEN}✓ Caractères spéciaux détectés${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Caractères spéciaux non détectés${NC}"

# Test 7: Score/Niveau affiché (1pt)
echo "$OUTPUT" | grep -qiE "score|niveau|level" && { echo -e "${GREEN}✓ Score/Niveau affiché${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Score/Niveau non affiché${NC}"

echo ""; echo "Score : $SCORE / $MAX"

# Retourner un code d'erreur si le score n'est pas parfait (pour GitHub Classroom)
if (( $(echo "$SCORE < $MAX" | bc -l) )); then
    exit 1
else
    exit 0
fi
