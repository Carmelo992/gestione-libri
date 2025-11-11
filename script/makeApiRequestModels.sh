#!/bin/bash

# Interrompe immediatamente lo script se un comando fallisce.
set -e

source "$(dirname "$0")/utils.sh"

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
# Questo rende la ricerca dei template molto più affidabile.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Definisce i percorsi dei template
TEMPLATE_CREATE_PATH="${SCRIPT_DIR}/template/api_request_model_template"
TEMPLATE_UPDATE_PATH="${SCRIPT_DIR}/template/api_request_update_model_template"

# Controlla se i file template esistono prima di procedere
if [[ ! -f "$TEMPLATE_CREATE_PATH" ]] || [[ ! -f "$TEMPLATE_UPDATE_PATH" ]]; then
    echo "Errore: Uno o più file template non sono stati trovati." >&2
    echo "Percorso controllato per il template di creazione: $TEMPLATE_CREATE_PATH" >&2
    echo "Percorso controllato per il template di aggiornamento: $TEMPLATE_UPDATE_PATH" >&2
    exit 1
fi

# -- Variabili per il Modulo --
module_name_raw="$1"
module_name_lower=$(echo "$module_name_raw" | tr '[:upper:]' '[:lower:]')
module_name_pascal=$(to_pascal_case "$module_name_raw")
module_name_camel=$(to_camel_case "$module_name_raw")

# -- Variabili di percorso --
output_dir="api_request_models"
create_model_file="${output_dir}/${module_name_lower}_model.dart"
update_model_file="${output_dir}/update_${module_name_lower}_model.dart"

# ==============================================================================
# Logica Principale
# ==============================================================================

echo "Creazione della directory: $output_dir"
mkdir -p "$output_dir" # L'opzione -p evita errori se la directory esiste già

echo "Copia del template di creazione in: $create_model_file"
cp "$TEMPLATE_CREATE_PATH" "$create_model_file"

echo "Copia del template di aggiornamento in: $update_model_file"
cp "$TEMPLATE_UPDATE_PATH" "$update_model_file"

echo "Sostituzione dei placeholder per il file di creazione..."
# Combina tutte le sostituzioni in un unico comando 'sed' per efficienza
sed -i '' \
    -e "s@MODULE_PASCAL@$module_name_pascal@g" \
    -e "s@MODULE_CAMEL@$module_name_camel@g" \
    -e "s@MODULE@$module_name_lower@g" \
    "$create_model_file"

echo "Sostituzione dei placeholder per il file di aggiornamento..."
sed -i '' \
    -e "s@MODULE_PASCAL@$module_name_pascal@g" \
    -e "s@MODULE_CAMEL@$module_name_camel@g" \
    -e "s@MODULE@$module_name_lower@g" \
    "$update_model_file"

echo ""
echo "Modelli API per '$module_name_raw' creati con successo nella directory '$output_dir'."

