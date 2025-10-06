#!/bin/bash

# Interrompe immediatamente lo script se un comando fallisce.
set -e

# ==============================================================================
# Funzioni di Utilità
# ==============================================================================

# Funzione per convertire una stringa in PascalCase (es. nome_modulo -> NomeModulo)
# Argomento 1: La stringa da convertire
to_pascal_case() {
    # Converte l'intera stringa in minuscolo
    local lower_case
    lower_case=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    # Rende maiuscola la prima lettera
    local first_char
    first_char=$(echo "${lower_case:0:1}" | tr '[:lower:]' '[:upper:]')

    # Concatena la prima lettera maiuscola con il resto della stringa
    echo "$first_char${lower_case:1}"
}

# ==============================================================================
# Validazione degli Input
# ==============================================================================

# Controlla che il nome del modulo sia stato fornito
if [[ -z "$1" ]]; then
    echo "Errore: Nome del modulo non fornito." >&2
    echo "Uso: $0 <NomeModulo>" >&2
    exit 1
fi

# ==============================================================================
# Definizione delle Variabili e dei Percorsi
# ==============================================================================

# Ottiene il percorso assoluto della directory in cui si trova questo script.
# Questo rende la ricerca del template molto più affidabile.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Definisce il percorso del template in modo robusto
TEMPLATE_PATH="${SCRIPT_DIR}/template/export_template"

# Controlla se il file template esiste prima di procedere
if [[ ! -f "$TEMPLATE_PATH" ]]; then
    echo "Errore: File template non trovato in '$TEMPLATE_PATH'" >&2
    exit 1
fi

# -- Variabili per il Modulo --
module_name_raw="$1"
module_name_lower=$(echo "$module_name_raw" | tr '[:upper:]' '[:lower:]')
module_name_pascal=$(to_pascal_case "$module_name_raw")

# -- Nome del file di output --
output_filename="${module_name_lower}.dart"

# ==============================================================================
# Logica Principale
# ==============================================================================

echo "Copia del template in: $output_filename"
cp "$TEMPLATE_PATH" "$output_filename"

echo "Sostituzione dei placeholder nel file: $output_filename"
# Combina tutte le sostituzioni in un unico comando 'sed' per efficienza,
# usando l'opzione -e per ogni espressione.
sed -i '' \
    -e "s@MODULE_CAMEL@$module_name_pascal@g" \
    -e "s@MODULE@$module_name_lower@g" \
    "$output_filename"

echo ""
echo "File di export '$output_filename' creato con successo."

