#!/bin/bash
# /c/Users/jtiss/dev-tools/modules/check_git_clean.sh

check_git_clean_logic() {
    # On exécute git status court (-s). Si la sortie n'est pas vide (-n), 
    # cela signifie qu'il y a des fichiers modifiés ou non suivis.
    if [[ -n $(git status -s) ]]; then
        echo "❌ [jtflow] Erreur : Ton dossier de travail n'est pas propre. Commit ou stash tes changements."
        return 1
    else
        echo "✅ [jtflow] Statut Git : Propre."
        return 0
    fi
}