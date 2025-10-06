#!/bin/bash

# Interrompe immediatamente lo script se un comando fallisce.
set -e

# ==============================================================================
# Validazione dell'Input
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

# Il nome del modulo passato come primo argomento
MODULE_NAME="$1"

# Definisce il percorso dello script 'makeAdapter.sh' in modo più robusto.
# SCRIPT_DIR contiene il percorso della directory in cui si trova questo script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MAKE_ADAPTER_SCRIPT_PATH="${SCRIPT_DIR}/makeAdapter.sh"

# Directory di output per gli adapter
OUTPUT_DIR="adapters"

# Controlla se lo script 'makeAdapter.sh' esiste e può essere eseguito
if [[ ! -x "$MAKE_ADAPTER_SCRIPT_PATH" ]]; then
    echo "Errore: Lo script 'makeAdapter.sh' non è stato trovato o non è eseguibile." >&2
    echo "Percorso controllato: $MAKE_ADAPTER_SCRIPT_PATH" >&2
    exit 1
fi

# ==============================================================================
# Logica Principale
# ==============================================================================

echo "Creazione della directory di output: $OUTPUT_DIR"
# L'opzione -p evita errori se la directory esiste già.
mkdir -p "$OUTPUT_DIR"

# Entra nella directory di output. In questo caso è giustificato perché lo
# script 'makeAdapter.sh' è pensato per essere eseguito da lì.
cd "$OUTPUT_DIR"

echo "--- Generazione dell'adapter API ---"
# Esegue lo script 'makeAdapter.sh' per il target 'api'.
# Usiamo il percorso assoluto per essere sicuri di trovarlo.
"$MAKE_ADAPTER_SCRIPT_PATH" "$MODULE_NAME" "api"

echo "--- Generazione dell'adapter Web ---"
# Esegue lo script 'makeAdapter.sh' per il target 'web'.
"$MAKE_ADAPTER_SCRIPT_PATH" "$MODULE_NAME" "web"

echo "" # Aggiunge una riga vuota per leggibilità
echo "Operazione completata con successo."
echo "Gli adapter per '$MODULE_NAME' sono stati creati nella directory '$OUTPUT_DIR'."

