#!/bin/bash
# /c/Users/jtiss/dev-tools/tests/test_check_pom_exists.sh

source "$(dirname "$0")/assertions.sh"
source "$(dirname "$0")/../modules/check_pom_exists.sh"

echo "🧪 Lancement des tests pour check_pom_exists..."

# Cas 1 : Échec si aucun pom.xml n'est présent
# On crée un dossier vide temporaire pour être sûr qu'il n'y a pas de pom.xml
mkdir -p temp_sans_pom && cd temp_sans_pom

if check_pom_exists_logic > /dev/null 2>&1; then
    echo -e "\033[0;31mFAIL\033[0m: Le module aurait dû échouer sans pom.xml"
    cd .. && rm -rf temp_sans_pom
    exit 1
else
    echo -e "\033[0;32mPASS\033[0m: Le module détecte bien l'absence de pom.xml"
fi
cd .. && rm -rf temp_sans_pom

# Cas 2 : Succès si un pom.xml est présent
touch pom.xml
assert_success "check_pom_exists_logic" "Le module doit réussir si pom.xml existe"
rm pom.xml