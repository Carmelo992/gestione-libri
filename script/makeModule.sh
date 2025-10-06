#!/bin/bash

# Interrompe immediatamente lo script se un comando fallisce o se si usa
# una variabile non definita (utile per trovare typo).
set -eu

# ==============================================================================
# Validazione dell'Input
# ==============================================================================

# Controlla che il nome del modulo sia stato fornito
if [[ -z "$1" ]]; then
    # Scrive l'errore sullo standard error (canale 2)
    echo "Errore: Nome del modulo non fornito." >&2
    echo "Uso: $0 <NomeModulo>" >&2
    exit 1
fi

MODULE_NAME="$1"

echo  "***"
# ==============================================================================
# Definizione Robusta dei Percorsi
# ==============================================================================

# Ottiene il percorso assoluto della directory in cui si trova questo script.
# Questo rende la localizzazione degli altri script e directory a prova di errore.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Definisce i percorsi chiave basandosi sulla posizione dello script
PROJECT_ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BIN_DIR="${PROJECT_ROOT_DIR}/bin"
MODULE_DIR="${BIN_DIR}/${MODULE_NAME}"

# Array contenente i percorsi di tutti gli script che verranno chiamati
# In questo modo, possiamo validarli tutti in un unico ciclo.
REQUIRED_SCRIPTS=(
    "${SCRIPT_DIR}/makeAdapters.sh"
    "${SCRIPT_DIR}/makeApiRequestModels.sh"
    "${SCRIPT_DIR}/makeDao.sh"
    "${SCRIPT_DIR}/addFields.sh"
    "${SCRIPT_DIR}/makeExport.sh"
    "${SCRIPT_DIR}/updateDatabase.sh"
    "${PROJECT_ROOT_DIR}/generateAdapter.sh"
)

# Controlla che tutti gli script necessari esistano e siano eseguibili
for script_path in "${REQUIRED_SCRIPTS[@]}"; do
    if [[ ! -x "$script_path" ]]; then
        echo "Errore: Lo script richiesto non è stato trovato o non è eseguibile." >&2
        echo "Percorso controllato: $script_path" >&2
        exit 1
    fi
done

# ==============================================================================
# Logica Principale
# ==============================================================================

echo "Inizio della creazione del modulo '$MODULE_NAME'..."

echo "-> Creazione della directory del modulo in: ${MODULE_DIR}"
mkdir -p "$MODULE_DIR"

# Imposta la directory di lavoro una sola volta per tutti gli script figli.
# Questo è un caso in cui `cd` è utile, perché tutti gli script successivi
# si aspettano di essere eseguiti da questa posizione.
cd "$MODULE_DIR"

echo "  - Creazione adapters..."
"${SCRIPT_DIR}/makeAdapters.sh" "$MODULE_NAME"

echo "  - Creazione API request models..."
"${SCRIPT_DIR}/makeApiRequestModels.sh" "$MODULE_NAME"

echo "  - Creazione DAO..."
"${SCRIPT_DIR}/makeDao.sh" "$MODULE_NAME"

echo "  - Aggiunta campi al modello..."
"${SCRIPT_DIR}/addFields.sh" "$MODULE_NAME"

echo "  - Creazione file di export..."
"${SCRIPT_DIR}/makeExport.sh" "$MODULE_NAME"

echo "  - Aggiornamento database..."
"${SCRIPT_DIR}/updateDatabase.sh" "$MODULE_NAME"

# Ritorna alla root del progetto per eseguire lo script di generazione finale
cd "$PROJECT_ROOT_DIR"

echo "  - Generazione adapters finali..."
./generateAdapter.sh

echo ""
echo "✅ Creazione modulo completata con successo."

# Sezione commit (commentata come nell'originale)
# echo "✍️ Esecuzione del commit..."
# git add .
# git commit -m "feat: Added module '$MODULE_NAME'"

# echo "🎉 Commit eseguito. Modulo '$MODULE_NAME' aggiunto correttamente."
