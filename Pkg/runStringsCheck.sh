#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SFILE="$SCRIPT_DIR/../Sources/Utilities/String+Localized.swift"
LFILES=$(find "$SCRIPT_DIR/.." -name "Localizable.strings")

# Obtém a lista de strings do arquivo String+Localized.swift
CASES=$(grep -o "case [^= ]*" "$SFILE" | cut -c 6-)
KEYS=$(grep -o "case [^=]* = \"[^\"]*\"" "$SFILE" | sed 's/^case \([^=]*\) = "\(.*\)"/\2/g')
STRINGS=$(paste -d "|" <(echo "$CASES") <(echo "$KEYS"))

FOUND_FAILURE=0
CACHE=()

get_cached_file_content() {
    local file_path="$1"
    if [ -z "${CACHE[$2]}" ]; then
        CACHE[$2]="$(cat "$file_path")"
    fi
    echo "${CACHE[$2]}"
}

get_language() {
    local dirname=$(dirname "$1")
    local lang=$(basename "$dirname")
    echo "${lang%.*}"
}

check_key_exists() {
    local KEY="$1"
    echo -ne " |  "
    for FILE in $LFILES; do
        LANGUAGE=$(get_language "$FILE")
        if 
            get_cached_file_content "$FILE" "$LANGUAGE" | \
            egrep -q "\"$KEY\"[[:space:]]*=[[:space:]]*\"(\\\"|[^\"])+\"[[:space:]]*;";
        then
            echo -ne "\033[0;32m"
        else
            echo -ne "\033[0;31m"
            FOUND_FAILURE=$((FOUND_FAILURE + 1))
            STRINGSFAILURE=true
        fi
        echo -n "$LANGUAGE"
        echo -ne "\033[0m  |  "
    done
}

tabulate_string() {
    NUM_CHARS=$(($2))
    LENGTH=${#1}
    CURRENT_LENGTH=$((LENGTH+NUM_CHARS))

    echo -n "$1$(printf ' %.0s' $(seq 1 $((NUM_CHARS-(CURRENT_LENGTH%NUM_CHARS)))) )"
}


while IFS="|" read -r CASE KEY; do
    # Obtém o número de ocorrências dessa string no código fonte
    COUNT=$(grep -r -o "\.$CASE\b" "$SCRIPT_DIR/../Sources" | wc -l)
    KEYFAILURE=false
    STRINGSFAILURE=false

    check_key_exists "$KEY"

    if [ "$COUNT" -lt 1 ]; then
        FOUND_FAILURE=$((FOUND_FAILURE + 1))
        KEYFAILURE=true
        echo -ne "\033[0;31m"
    else
        echo -ne "\033[0;32m"
    fi

    echo -ne "used $(($COUNT + 0)) times"
    echo -ne "\033[0m  |\t"

    if $KEYFAILURE; then
        echo -ne "\033[31m"
    fi
    echo -ne "$(tabulate_string $CASE 40) "
    echo -ne "\033[0m"

    if $STRINGSFAILURE; then
        echo -ne "\033[31m"
    fi
    echo -ne "\"$KEY\""
    echo -e "\033[0m"

done <<<"$STRINGS"

if [ "$FOUND_FAILURE" -gt 0 ]; then
    echo ""
    echo "Found $FOUND_FAILURE failures."
    exit 1
fi
