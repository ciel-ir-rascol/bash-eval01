#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
SCRIPT="./compteur_fichiers.sh"
TEST_DIR="/tmp/test_compteur_$$"
SCORE=0; MAX=4

echo "=========================================="
echo "Test Ex5 BONUS : Compteur fichiers"
echo "=========================================="
echo ""

[ ! -f "$SCRIPT" ] && echo -e "${RED}❌ Script inexistant${NC}" && exit 1
chmod +x "$SCRIPT" 2>/dev/null

# Créer environnement de test
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR/subdir"
touch "$TEST_DIR/file1.txt" "$TEST_DIR/file2.txt" "$TEST_DIR/file3.txt"
touch "$TEST_DIR/script1.sh" "$TEST_DIR/script2.sh"
touch "$TEST_DIR/image.jpg"
touch "$TEST_DIR/subdir/data.txt"

# Test 1: Vérification paramètre (0.5pt)
$SCRIPT > /dev/null 2>&1 && echo -e "${RED}✗ Devrait échouer sans paramètre${NC}" || { echo -e "${GREEN}✓ Vérification paramètre OK${NC}"; SCORE=$(echo "$SCORE + 0.5" | bc); }

OUTPUT=$($SCRIPT "$TEST_DIR" 2>&1)

# Test 2: Utilisation de find (1pt)
grep -q "find" "$SCRIPT" && { echo -e "${GREEN}✓ Commande find utilisée${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Commande find non trouvée${NC}"

# Test 3: Extraction extension (1pt)
grep -qE "##\*\.|%\.\*|\.tar" "$SCRIPT" && { echo -e "${GREEN}✓ Extraction extension détectée${NC}"; SCORE=$(echo "$SCORE + 1" | bc); } || echo -e "${RED}✗ Extraction extension non détectée${NC}"

# Test 4: Comptage .txt (0.75pt)
echo "$OUTPUT" | grep -iE "\.txt.*4" && { echo -e "${GREEN}✓ Comptage .txt correct (4)${NC}"; SCORE=$(echo "$SCORE + 0.75" | bc); } || echo -e "${RED}✗ Comptage .txt incorrect${NC}"

# Test 5: Comptage .sh (0.75pt)
echo "$OUTPUT" | grep -iE "\.sh.*2" && { echo -e "${GREEN}✓ Comptage .sh correct (2)${NC}"; SCORE=$(echo "$SCORE + 0.75" | bc); } || echo -e "${RED}✗ Comptage .sh incorrect${NC}"

rm -rf "$TEST_DIR"

echo ""; echo "Score BONUS : $SCORE / $MAX"
