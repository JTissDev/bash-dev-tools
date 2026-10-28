# ------------------------------------------------------------------------------
# Block   : Helpers & Documentation
# Desc    : Affiche le menu d'aide dynamique scannant tous les scripts de dev-tools par blocs
# Usage   : dev-help
# Author  : J.Tiss <jtissdev@gmail.com>
# ------------------------------------------------------------------------------
function dev-help() {
    echo -e "\n🛠️  === MES COMMANDES DEV-TOOLS ===\n"

    find "$DEV_TOOLS_HOME" -type f -name "*.sh" -exec awk '
    
    # 1. Capture des balises
    /#[[:space:]]*(Desc|Description)[[:space:]]*:/ {
        desc = substr($0, index($0, ":") + 1); sub(/^[[:space:]]+/, "", desc)
    }
    /#[[:space:]]*Usage[[:space:]]*:/ {
        usage = substr($0, index($0, ":") + 1); sub(/^[[:space:]]+/, "", usage)
    }
    /#[[:space:]]*Helper[[:space:]]*:/ {
        helper = substr($0, index($0, ":") + 1); sub(/^[[:space:]]+/, "", helper)
    }
    /#[[:space:]]*(Options|Parameters)[[:space:]]*:/ {
        opts = substr($0, index($0, ":") + 1); sub(/^[[:space:]]+/, "", opts)
    }
    /#[[:space:]]*Block[[:space:]]*:/ {
        block_cat = substr($0, index($0, ":") + 1); sub(/^[[:space:]]+/, "", block_cat)
    }

    # 2. Détection de la fonction
    /^[[:space:]]*(function[[:space:]]+)?[A-Za-z0-9_-]+[[:space:]]*\(\)/ {
        func_name = $0
        sub(/^[[:space:]]*function[[:space:]]+/, "", func_name)
        sub(/[[:space:]]*\(\).*$/, "", func_name)

        if (func_name !~ /^_/ && desc != "") {
            
            # Valeur par défaut si aucun bloc n est spécifié
            if (block_cat == "") block_cat = "Général"

            # Construction directe de la fiche avec de vrais retours à la ligne
            f_block = sprintf("  \033[1;36m%s\033[0m", func_name)
            
            if (usage != "") {
                f_block = f_block "\n       \033[90mCommande :\033[0m \033[33m" usage "\033[0m"
            } else {
                f_block = f_block "\n       \033[90mCommande :\033[0m \033[33m" func_name "\033[0m"
            }

            f_block = f_block "\n       \033[90mDesc     :\033[0m " desc
            if (opts != "")   f_block = f_block "\n       \033[90mOptions  :\033[0m " opts
            if (helper != "") f_block = f_block "\n       \033[90mHelper   :\033[0m \033[35m" helper "\033[0m"

            # On accumule dans le tableau du bloc
            if (blocks[block_cat] == "") {
                blocks[block_cat] = f_block
            } else {
                blocks[block_cat] = blocks[block_cat] "\n\n" f_block
            }
        }

        # Reset strict des variables
        desc = ""; usage = ""; opts = ""; helper = ""; block_cat = ""
    }

    # 3. Affichage final propre par blocs
    END {
        for (cat in blocks) {
            print "\n\033[1;33m📁 [" cat "]\033[0m"
            print "-------------------------------------------------"
            print blocks[cat]
        }
    }' {} +

    echo -e "\n=================================================\n"
}