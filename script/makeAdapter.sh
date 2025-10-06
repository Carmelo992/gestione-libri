#!/bin/bash

# Interrompe immediatamente lo script se un comando fallisce.
# Molto utile per evitare comportamenti imprevisti.
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

# Controlla che entrambi gli argomenti siano stati forniti
if [[ -z "$1" || -z "$2" ]]; then
    echo "Errore: Argomenti mancanti." >&2
    echo "Uso: $0 <NomeModulo> <NomeTarget>" >&2
    exit 1
fi

# ==============================================================================
# Definizione delle Variabili
# ==============================================================================

# Definisce il percorso del template per una migliore manutenibilità
TEMPLATE_PATH="../../../script/template/adapter_template"

# Controlla se il file template esiste prima di procedere
if [[ ! -f "$TEMPLATE_PATH" ]]; then
    echo "Errore: File template non trovato in '$TEMPLATE_PATH'" >&2
    exit 1
fi

# -- Variabili per il Modulo --
module_name_raw="$1"
module_name_lower=$(echo "$module_name_raw" | tr '[:upper:]' '[:lower:]')
module_name_pascal=$(to_pascal_case "$module_name_raw")

# -- Variabili per il Target --
target_name_raw="$2"
target_name_lower=$(echo "$target_name_raw" | tr '[:upper:]' '[:lower:]')
target_name_pascal=$(to_pascal_case "$target_name_raw")

# -- Variabili di percorso --
adapter_dir="${target_name_lower}_adapter"
output_filename="${target_name_lower}_${module_name_lower}_adapter.dart"
output_filepath="${adapter_dir}/${output_filename}"

# ==============================================================================
# Logica Principale
# ==============================================================================

echo "Creazione della directory: $adapter_dir"
mkdir -p "$adapter_dir" # L'opzione -p evita errori se la directory esiste già

echo "Copia del template in: $output_filepath"
cp "$TEMPLATE_PATH" "$output_filepath"

echo "Sostituzione dei placeholder nel file: $output_filename"
# Combina tutte le sostituzioni in un unico comando 'sed' per efficienza,
# usando l'opzione -e per ogni espressione.
sed -i '' \
    -e "s@MODULE_CAMEL@$module_name_pascal@g" \
    -e "s@MODULE@$module_name_lower@g" \
    -e "s@TARGET_CAMEL@$target_name_pascal@g" \
    -e "s@TARGET@$target_name_lower@g" \
    "$output_filepath"

echo "Adapter '$output_filename' creato con successo nella directory '$adapter_dir'."
# Rimuovo 'cd' per evitare di cambiare la directory di lavoro dello script,
# una pratica generalmente più sicura.

