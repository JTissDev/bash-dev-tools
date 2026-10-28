# ------------------------------------------
# Block   : Utilitaires
# Name        : add-alias
# Description : Dynamically adds an alias into a specific section of .bash_aliases
#               located in ~/dev-tools/config/ and reloads the configuration.
# Options : $1 = Nom de l'alias, $2 = Commande, $3 = Section (nav/proj/util)
# Usage       : add-alias <name> "<command>" [section]
# Examples    : add-alias root "cd /c/dev" navigation     # Creates: root-nav
#               add-alias api "cd ~/projects/api" projects # Creates: api-proj
#               add-alias cls "clear" utilities            # Creates: cls-util
# Author  : J.Tiss <jtissdev@gmail.com>
# ------------------------------------------
add-alias() {
    local alias_name="$1"
    local command="$2"
    local section="${3:-}"
    local aliases_file="$HOME/dev-tools/config/.bash_aliases"
    local suffix=""

    # 1. Verify required arguments
    if [ -z "$alias_name" ] || [ -z "$command" ]; then
        echo "⚠️  Error: Missing required arguments."
        echo "📖 Usage: add-alias <name> \"<command>\" [section]"
        return 1
    fi

    # 2. Check if aliases file exists
    if [ ! -f "$aliases_file" ]; then
        echo "⚠️  Error: File not found at ${aliases_file}"
        return 1
    fi

    # 3. Map section argument to header format
    local target_header=""
    case "${section,,}" in
        nav|navigation)
            target_header="# === NAVIGATION ==="
            suffix="-nav"
            ;;
        proj|project|projects)
            target_header="# === PROJECTS ==="
            suffix="-proj"
            ;;
        util|utility|utilities|utils)
            target_header="# === UTILITIES ==="
            suffix="-util"
            ;;
        "")
            target_header=""
            suffix=""  # No suffix if no section is specified
            ;;
        *)
            # Format custom section name in uppercase
            target_header="# === ${section^^} ==="
            ;;
    esac

    # 4. Add suffix to alias name if section is specified
    local final_alias_name="${alias_name}${suffix}"
    local alias_line="alias ${final_alias_name}='${command}'"

    # 5. Insert alias into section or append to end of file
    if [ -n "$target_header" ] && grep -qF "$target_header" "$aliases_file"; then
        # Insert line right after section header line using sed
        sed -i "/^${target_header}/a ${alias_line}" "$aliases_file"
        echo "✅ Alias '${final_alias_name}' added under '${target_header}' section."
    else
        # If section header does not exist, append header and alias at the end
        if [ -n "$target_header" ]; then
            echo "" >> "$aliases_file"
            echo "$target_header" >> "$aliases_file"
            echo "ℹ️  Created new section '${target_header}' in ${aliases_file}"
        fi
        echo "$alias_line" >> "$aliases_file"
        echo "✅ Alias '${final_alias_name}' added to ${aliases_file}"
    fi

    # 5. Reload configuration
    if source "$HOME/.bashrc"; then
        echo "🚀 Configuration successfully reloaded!"
    else
        echo "⚠️  Alias saved, but reloading ~/.bashrc failed."
    fi
}