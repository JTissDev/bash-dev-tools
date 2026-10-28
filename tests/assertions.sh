#!/bin/bash
# /c/Users/jtiss/dev-tools/tests/assertions.sh

# Couleurs pour le terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 1. Vérifie si deux valeurs sont égales
assert_eq() {
    local expected="$1"
    local actual="$2"
    local message="$3"

    if [ "$expected" == "$actual" ]; then
        echo -e "${GREEN}PASS${NC}: $message"
    else
        echo -e "${RED}FAIL${NC}: $message"
        echo -e "  > Attendu : '$expected'"
        echo -e "  > Reçu    : '$actual'"
        exit 1
    fi
}

# 2. Vérifie si une commande réussit (code retour 0)
assert_success() {
    local command="$1"
    local message="$2"

    if eval "$command"; then
        echo -e "${GREEN}PASS${NC}: $message"
    else
        echo -e "${RED}FAIL${NC}: $message"
        echo -e "  > La commande a échoué : $command"
        exit 1
    fi
}

# 3. Vérifie si un fichier existe
assert_file_exists() {
    local file="$1"
    local message="$2"

    if [ -f "$file" ]; then
        echo -e "${GREEN}PASS${NC}: $message"
    else
        echo -e "${RED}FAIL${NC}: $message"
        echo -e "  > Le fichier n'existe pas : $file"
        exit 1
    fi
}