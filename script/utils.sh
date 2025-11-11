#!/bin/bash

# ==============================================================================
# Funzioni di Utilità per Stringhe
# ==============================================================================

# Funzione per convertire una stringa snake_case in lowerCase
to_lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Funzione per convertire una stringa snake_case in upperCase
to_upper() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Funzione per convertire una stringa snake_case in camelCase
to_camel_case() {
    echo "$1" | awk -F_ '{printf "%s", $1; for(i=2; i<=NF; i++) {printf "%s%s", toupper(substr($i,1,1)), substr($i,2)}}'
}

# Funzione per convertire una stringa in PascalCase (es. nome_modulo -> NomeModulo)
# Argomento 1: La stringa da convertire
to_pascal_case() {
    # Converte l'intera stringa in minuscolo
    local lower_case
    to_camel_case=$(to_camel_case "$1")

    # Rende maiuscola la prima lettera
    local first_char
    first_char=$(echo "${to_camel_case:0:1}" | tr '[:lower:]' '[:upper:]')

    # Concatena la prima lettera maiuscola con il resto della stringa
    echo "$first_char${to_camel_case:1}"
}

echo "Input " $1
echo "Camel case " $(to_camel_case $1)
echo "Pascal case " $(to_pascal_case $(to_camel_case $1))
