# ==============================================================================
# File        : gitignore_helpers.sh
# Description : Helper functions for detecting project types, parsing metadata,
#               and generating custom .gitignore files.
# Author      : J.Tiss <jtissdev@gmail.com>
# ==============================================================================

# ------------------------------------------------------------------------------
# Function    : parse_pom_xml
# Block   : Git & Workflow
# Desc    : Extrait l'artifactId d'un fichier pom.xml s'il est disponible
# Usage   : parse_pom_xml
# Author  : J.Tiss <jtissdev@gmail.com>
# Outputs     : Echoes "artifactId" or empty string if not found.
# ------------------------------------------------------------------------------
parse_pom_xml() {
    local pom_file="pom.xml"

    if [ -f "$pom_file" ]; then
        # Extract first occurrence of artifactId using sed
        sed -n 's/.*<artifactId>\(.*\)<\/artifactId>.*/\1/p' "$pom_file" | head -n 1
    else
        echo ""
    fi
}

# ------------------------------------------------------------------------------
# Function    : detect_project_type
# Block   : Git & Workflow
# Desc    : Auto-detects project stack based on configuration files.
# Returns     : Echoes 'java', 'node', 'php', or 'general'.
# ------------------------------------------------------------------------------
detect_project_type() {
    if [ -f "pom.xml" ]; then
        echo "java"
    elif [ -f "package.json" ]; then
        echo "node"
    elif [ -f "composer.json" ]; then
        echo "php"
    else
        echo "general"
    fi
}

# ------------------------------------------------------------------------------
# Function    : create_default_gitignore
# Block   : Git & Workflow
# Desc    : Génère un fichier .gitignore personnalisé avec en-tête de métadonnées
# Usage   : create_default_gitignore [type] [name]
# Options : $1 = Type de projet (java, node, php, all), $2 = Nom personnalisé
# Author  : J.Tiss <jtissdev@gmail.com>
# ------------------------------------------------------------------------------
create_default_gitignore() {
    local gitignore_file=".gitignore"
    local type_param="${1:-}"
    local custom_name="${2:-}"

    if [ -f "$gitignore_file" ]; then
        echo "ℹ️  An existing .gitignore file was found. Skipping creation."
        return 0
    fi

    # 1. Determine Project Metadata
    local project_name="Generic Project"
    local current_date
    current_date=$(date +"%Y-%m-%d")

    # Try to extract artifactId from pom.xml first
    local pom_name
    pom_name=$(parse_pom_xml)

    if [ -n "$pom_name" ]; then
        project_name="$pom_name"
    fi

    # Override with parameter if explicitly provided
    [ -n "$custom_name" ] && project_name="$custom_name"

    # 2. Determine Project Type
    local project_type=""
    if [ -n "$type_param" ]; then
        project_type="${type_param,,}"
    else
        project_type=$(detect_project_type)
        echo "🔍 Auto-detected project type: ${project_type}"
    fi

    echo "📝 Generating customized .gitignore file for '${project_name}' (${project_type})..."

    # 3. Write Header
    cat << EOF > "$gitignore_file"
# ==============================================================================
# Project     : ${project_name}
# Author      : J.Tiss <jtissdev@gmail.com>
# Generated   : ${current_date}
# Type        : ${project_type^^}
# ==============================================================================

# ==========================================
# Operating System (Windows / macOS / Linux)
# ==========================================
Thumbs.db
Desktop.ini
ehthumbs.db
\$RECYCLE.BIN/
*.stackdump
*.lnk

# ==========================================
# IDEs & Editors (IntelliJ IDEA / VS Code / Eclipse)
# ==========================================
.idea/
*.iml
*.iws
*.ipr
out/
.vscode/
*.code-workspace
.classpath
.project
.settings/
.factorypath

EOF

    # 4. Append Conditional Rules based on Project Type

    # Java / Maven Section
    if [[ "$project_type" == "java" || "$project_type" == "all" ]]; then
        cat << 'EOF' >> "$gitignore_file"
# ==========================================
# Java & Spring Boot / Maven
# ==========================================
target/
*.class
*.jar
*.war
*.ear
*.nar
*.rar
*.log
.mtj.tmp/
*.pot

EOF
    fi

    # Node.js / React Section
    if [[ "$project_type" == "node" || "$project_type" == "react" || "$project_type" == "all" ]]; then
        cat << 'EOF' >> "$gitignore_file"
# ==========================================
# Web Front-End (Node.js / React / NPM / Yarn)
# ==========================================
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*
build/
dist/
.cache/
.parcel-cache/

EOF
    fi

    # PHP & Composer Section
    if [[ "$project_type" == "php" || "$project_type" == "all" ]]; then
        cat << 'EOF' >> "$gitignore_file"
# ==========================================
# PHP & Composer
# ==========================================
vendor/
composer.phar
.phpunit.result.cache

EOF
    fi

    # Common Environment, Databases & Temp Files Section
    cat << 'EOF' >> "$gitignore_file"
# ==========================================
# Databases & Local Storage
# ==========================================
*.sql
*.sqlite
*.sqlite3
*.db
*.accdb
*.ldb

# ==========================================
# Environment & Configuration Files (Secrets)
# ==========================================
.env
.env.*
!.env.example
!.env.template

# ==========================================
# Temporary Files & Archives
# ==========================================
*.tmp
*.bak
*.swp
*.swo
*.zip
*.tar.gz
*.7z
EOF

    echo "✅ Customized .gitignore generated successfully!"
    return 0
}