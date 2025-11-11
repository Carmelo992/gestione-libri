#!/bin/bash

# Interrompe immediatamente lo script se un comando fallisce o se si usa
# una variabile non definita.
set -eu
cd ../core
ls

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

MODULE_NAME="$1"

# ==============================================================================
# Definizione Robusta dei Percorsi
# ==============================================================================

# Ottiene il percorso assoluto della directory in cui si trova questo script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Definisce i percorsi del progetto e del file da modificare in modo sicuro.
PROJECT_ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DATABASE_FILE_PATH="${PROJECT_ROOT_DIR}/bin/core/database.dart"

# Controlla se il file 'database.dart' esiste prima di tentare di modificarlo.
if [[ ! -f "$DATABASE_FILE_PATH" ]]; then
    echo "Errore: File 'database.dart' non trovato." >&2
    echo "Percorso controllato: $DATABASE_FILE_PATH" >&2
    exit 1
fi

# ==============================================================================
# Preparazione delle Variabili
# ==============================================================================

module_name_lower=$(echo "$MODULE_NAME" | tr '[:upper:]' '[:lower:]')
module_name_pascal=$(to_pascal_case "$MODULE_NAME")
module_name_camel=$(to_camel_case "$MODULE_NAME")

# -- Stringhe da inserire --
# Preparo tutte le linee di codice da inserire in anticipo per chiarezza.
# NOTA: La backslash in '..\/$moduleNameLower' deve essere escapata per sed.
import_line="import '..\/${module_name_lower}\/${module_name_lower}.dart';"
dao_line=$'\t'"static ${module_name_pascal}Dao ${module_name_camel}Dao = ${module_name_pascal}Dao(db);"
migration_line=$'\t\t\t'"${module_name_pascal}Dao.migrate(newDbVersion);"
create_table_line=$'\t\t'"db.execute(createTable(${module_name_pascal}Dao.tableName, ${module_name_pascal}Dao.tableColumns));"

# ==============================================================================
# Logica Principale
# ==============================================================================

echo "Aggiornamento del file 'database.dart' con il nuovo modulo '$MODULE_NAME'..."

# Unisce tutte le operazioni sed in un unico comando per massima efficienza.
# Ogni espressione '-e' modifica il file in memoria prima di salvarlo una sola volta.
sed -i '' \
    -e "/\/\/NEW_MODULE_PATH_PLACE_HOLDER/i\\
$import_line
" \
    -e "/\/\/NEW_MODULE_DAO_PLACE_HOLDER/i\\
$dao_line
" \
    -e "/\/\/NEW_MODULE_MIGRATION_PLACE_HOLDER/i\\
$migration_line
" \
    -e "/\/\/NEW_MODULE_CREATE_TABLE_PLACE_HOLDER/i\\
$create_table_line
" \
    "$DATABASE_FILE_PATH"

echo "✅ File 'database.dart' aggiornato con successo."
