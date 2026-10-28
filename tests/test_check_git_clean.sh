#!/bin/bash
# /c/Users/jtiss/dev-tools/tests/test_check_git_clean.sh

# 1. Import des assertions et du module à tester
source "$(dirname "$0")/assertions.sh"
source "$(dirname "$0")/../modules/check_git_clean.sh"

echo "🧪 Lancement des tests pour check_git_clean..."

# Simulation d'un cas PASS (Dépôt propre)
assert_success "check_git_clean_logic" "Le module doit réussir si le dépôt est propre"

# Simulation d'un cas FAIL (Dépôt modifié)
# Correction : on utilise .txt car .tmp est ignoré par le .gitignore !
touch salir_le_depot.txt

if check_git_clean_logic > /dev/null 2>&1; then
    echo -e "\033[0;31mFAIL\033[0m: Le module aurait dû échouer car le dépôt a un fichier non commité"
    rm salir_le_depot.txt
    exit 1
else
    echo -e "\033[0;32mPASS\033[0m: Le module détecte bien un dépôt modifié"
fi

# Nettoyage
rm salir_le_depot.txt
echo "✅ Tous les tests de check_git_clean sont passés !"