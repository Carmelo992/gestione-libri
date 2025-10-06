#!/bin/bash

# Interrompe immediatamente lo script se un comando fallisce o se si usa
# una variabile non definita, per una maggiore sicurezza.
set -eu

# ==============================================================================
# Definizione Robusta dei Percorsi
# ==============================================================================

# Ottiene il percorso assoluto della directory in cui si trova questo script.
# Questo rende la localizzazione del file 'strings.dart' a prova di errore.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Definisce il percorso del progetto e del file da modificare in modo sicuro.
PROJECT_ROOT_DIR=$SCRIPT_DIR
STRINGS_FILE_PATH="${PROJECT_ROOT_DIR}/bin/core/strings.dart"

# Controlla se il file 'strings.dart' esiste prima di tentare di modificarlo.
if [[ ! -f "$STRINGS_FILE_PATH" ]]; then
    echo "Errore: File 'strings.dart' non trovato." >&2
    echo "Percorso controllato: $STRINGS_FILE_PATH" >&2
    exit 1
fi

echo "Avvio della procedura per l'aggiunta di nuove stringhe di localizzazione..."
echo "File di destinazione: $STRINGS_FILE_PATH"
echo "---"

# ==============================================================================
# Logica Principale
# ==============================================================================

while true; do

    # --- Raccolta Input Utente ---
    read -r -p "Inserisci la chiave (lowerCamelCase, vuoto per uscire): " key
    # Se la chiave è vuota, usciamo dal ciclo.
    if [[ -z "$key" ]]; then
        echo "Nessuna chiave inserita. Uscita."
        break
    fi

    read -r -p "Inserisci il nome del metodo (lowerCamelCase): " methodName
    if [[ -z "$methodName" ]]; then
        echo "Errore: Il nome del metodo non può essere vuoto."
        continue # Ritorna all'inizio del ciclo per reinserire i dati
    fi

    read -r -p "Inserisci la traduzione in inglese [en]: " translation

    # --- Preparazione delle Stringhe da Inserire ---
    # Preparo tutte le linee di codice da inserire in anticipo per chiarezza.
    key_line="\t${key},"
    method_line="\n\tstatic String ${methodName}([String? lang]) => _get(StringKey.${key}, lang);"
    map_line="\t\tStringKey.${key}: {\"en\": \"${translation}\"},"

    # --- Aggiornamento del File ---
    echo "-> Aggiunta di '$key' al file..."

    # Unisce tutte le operazioni sed in un unico comando per massima efficienza.
    # Ogni espressione '-e' modifica il file in memoria prima di scriverlo una sola volta.
    # Usiamo il carattere "|" come delimitatore in sed per evitare problemi con i percorsi.
    sed -i '' \
        -e "s|//STRING_KEY|${key_line}\n//STRING_KEY|" \
        -e "s|//STRING_METHOD|${method_line}\n//STRING_METHOD|" \
        -e "s|//STRING_MAP_KEY|${map_line}\n//STRING_MAP_KEY|" \
        "$STRINGS_FILE_PATH"

    echo "Stringa '$key' aggiunta con successo."
    echo "---"

    # --- Chiede se continuare ---
    read -r -p "Vuoi aggiungere un'altra stringa? (Y/n): " readResult
    # Converte la risposta in minuscolo e controlla se è "n" o "no".
    response_lower=$(echo "$readResult" | tr '[:upper:]' '[:lower:]')
    if [[ "$response_lower" == "n" || "$response_lower" == "no" ]]; then
        break
    fi
done

echo "✅ Operazione completata."
