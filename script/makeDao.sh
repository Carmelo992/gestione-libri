#!/bin/bash

# Interrompe immediatamente lo script se un comando fallisce.
set -e

source "$(dirname "$0")/utils.sh"

# ==============================================================================
# Funzioni di Utilità
# ==============================================================================

# Funzione per processare un singolo file: copia e sostituzione
# Argomenti: 1=Percorso Template, 2=Percorso File di Output
process_template() {
    local template_path="$1"
    local output_file="$2"

    echo "Copia del template in: $output_file"
    cp "$template_path" "$output_file"

    echo "Sostituzione dei placeholder in: $(basename "$output_file")"
    sed -i '' \
        -e "s@MODULE_PASCAL@$module_name_pascal@g" \
        -e "s@MODULE_CAMEL@$module_name_camel@g" \
        -e "s@MODULE@$module_name_lower@g" \
        "$output_file"
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
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Definisce i percorsi dei template in modo robusto
TEMPLATE_DAO_PATH="${SCRIPT_DIR}/template/dao_template"
TEMPLATE_MODEL_PATH="${SCRIPT_DIR}/template/dao_model_template"
TEMPLATE_UPDATE_MODEL_PATH="${SCRIPT_DIR}/template/update_dao_model_template"

# Controlla se tutti i file template esistono prima di procedere
if [[ ! -f "$TEMPLATE_DAO_PATH" ]] || [[ ! -f "$TEMPLATE_MODEL_PATH" ]] || [[ ! -f "$TEMPLATE_UPDATE_MODEL_PATH" ]]; then
    echo "Errore: Uno o più file template non sono stati trovati nella directory 'template'." >&2
    exit 1
fi

# -- Variabili per il Modulo --
module_name_raw="$1"
module_name_lower=$(echo "$module_name_raw" | tr '[:upper:]' '[:lower:]')
module_name_camel=$(to_camel_case "$module_name_raw")
module_name_pascal=$(to_pascal_case "$module_name_raw")

# -- Variabili di percorso --
output_dir="dao"
dao_file="${output_dir}/${module_name_lower}_dao.dart"
model_dao_file="${output_dir}/${module_name_lower}_dao_model.dart"
update_model_dao_file="${output_dir}/update_${module_name_lower}_dao_model.dart"

# ==============================================================================
# Logica Principale
# ==============================================================================

echo "Creazione della directory di output: $output_dir"
mkdir -p "$output_dir" # L'opzione -p evita errori se la directory esiste già

# Processa ogni file usando la funzione helper
process_template "$TEMPLATE_DAO_PATH" "$dao_file"
process_template "$TEMPLATE_MODEL_PATH" "$model_dao_file"
process_template "$TEMPLATE_UPDATE_MODEL_PATH" "$update_model_dao_file"

echo ""
echo "File DAO per '$module_name_raw' creati con successo nella directory '$output_dir'."
