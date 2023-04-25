#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Obtém a lista de strings do arquivo String+Localized.swift
STRINGS=$(grep -o "case [^=]*" "$SCRIPT_DIR/../Sources/Utilities/String+Localized.swift" | cut -c 6-)
FOUND_FAILURE=0

# Itera sobre cada string
for STRING in $STRINGS; do
    # Obtém o número de ocorrências dessa string no código fonte
    COUNT=$(grep -r -o "\.$STRING\b" "$SCRIPT_DIR/../Sources" | wc -l)
    if [ "$COUNT" -lt 1 ]; then
        FOUND_FAILURE=$((FOUND_FAILURE+1))
        echo -ne "\033[0;31m"
        echo -e "unused:\t\t.$STRING"
    else
        echo -ne "\033[0;32m"
        echo -e  "used $(($COUNT+0)) times:\t.$STRING"
    fi
    echo -ne "\033[0m"
done

if [ "$FOUND_FAILURE" -gt 0 ]; then
    echo ""
    echo "Found $FOUND_FAILURE failures."
    exit 1
fi