#!/bin/bash
# /c/Users/jtiss/dev-tools/modules/check_pom_exists.sh

check_pom_exists_logic() {
    if [ ! -f "pom.xml" ]; then
        echo "❌ [jtflow] Erreur : Aucun fichier pom.xml trouvé dans le dossier courant."
        return 1
    else
        echo "✅ [jtflow] Fichier pom.xml détecté."
        return 0
    fi
}