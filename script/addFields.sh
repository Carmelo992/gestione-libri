#!/bin/bash

# ==============================================================================
# Funzioni di Utilità
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

# Funzione per convertire una stringa in PascalCase (prima lettera maiuscola)
to_pascal_case() {
    local str="$1"
    local first_char
    first_char=$(to_upper "${str:0:1}")
    echo "$first_char${str:1}"
}

# Funzione per inserire testo in un file usando un placeholder
# Argomenti: 1=Placeholder, 2=Testo da inserire, 3=File di destinazione
insert_code() {
    local placeholder="$1"
    local text_to_insert="$2"
    local target_file="$3"
    # Usa la sintassi su una sola riga, più robusta contro i problemi di indentazione
    sed -i '' "/\/\/${placeholder}/ i\\
${text_to_insert}
" "${target_file}"
}

# Funzione per chiedere conferma all'utente (Y/n)
confirm() {
    local question="$1"
    local response
    read -r -p "$question (Y/n): " response
    # Converte la risposta in minuscolo per un controllo più semplice
    [[ "$(to_lower $response)" =~ ^(y|yes)$ ]]
}

# ==============================================================================
# Inizializzazione e Setup
# ==============================================================================

# Controlla se il nome del modulo è stato fornito
if [[ -z "$1" ]]; then
    echo "Errore: Nessun nome del modulo fornito."
    echo "Uso: $0 <NomeModulo>"
    exit 1
fi

# Conversione dei nomi
moduleNameLower=$(echo "$1" | tr '[:upper:]' '[:lower:]')
moduleNamePascalCase=$(to_pascal_case "$moduleNameLower")

# Definizione dei nomi dei file
daoFileName="dao/${moduleNameLower}_dao.dart"
modelDaoFileName="dao/${moduleNameLower}_dao_model.dart"
modelUpdateDaoFileName="dao/update_${moduleNameLower}_dao_model.dart"
modelApiRequestFileName="api_request_models/${moduleNameLower}_model.dart"
modelApiRequestUpdateFileName="api_request_models/update_${moduleNameLower}_model.dart"

# ==============================================================================
# Logica Principale
# ==============================================================================

if ! confirm "Vuoi aggiungere campi personalizzati a questo modulo?"; then
    echo "Operazione annullata."
    exit 0
fi

while true; do

    # --- Raccolta Input Utente ---
    read -r -p "Inserisci il nome del campo (es. custom_field, lascia vuoto per uscire): " fieldName
    if [[ -z "$fieldName" ]]; then
        echo "Nessun campo inserito. Uscita dal ciclo."
        break
    fi

    fieldNameCamelCase=$(to_camel_case "$fieldName")

    read -r -p "Inserisci il tipo SQL (TEXT, INTEGER, TIMESTAMP): " fieldType
    # Converte in maiuscolo per rendere il controllo case-insensitive
    fieldTypeUpper=$(echo "$fieldType" | tr '[:lower:]' '[:upper:]')
    case "$fieldTypeUpper" in
        "TEXT"|"INTEGER"|"TIMESTAMP")
            # Tipo valido, continua
            ;;
        *)
            echo "Tipo non valido. Uscita dal ciclo."
            break
            ;;
    esac

    isNullable=true
    if ! confirm "Deve essere nullable?"; then
        isNullable=false
    fi

    hasDefault=false
    defaultValue=""
    if confirm "Ha un valore di default?"; then
        hasDefault=true
        read -r -p "Inserisci il valore di default: " defaultValue
    fi

    isUnique=false
    if confirm "Deve essere unico?"; then
        isUnique=true
    fi


    # --- Preparazione delle Stringhe da Inserire ---

    # SQL Column Definition
    columnRow="\${${moduleNamePascalCase}DaoModel.${fieldNameCamelCase}Key} $fieldTypeUpper"
    if [[ "$fieldTypeUpper" == "TIMESTAMP" ]]; then
        columnRow+=" DATETIME"
    fi
    if ! $isNullable; then
        columnRow+=" NOT NULL"
    fi
    if $hasDefault; then
        # Aggiunge apici per i valori di testo di default
        if [[ "$fieldTypeUpper" == "TEXT" || "$fieldTypeUpper" == "TIMESTAMP" ]]; then
            columnRow+=" DEFAULT '$defaultValue'"
        else
            columnRow+=" DEFAULT $defaultValue"
        fi
    fi

    # Dart Type
    case "$fieldTypeUpper" in
        "TEXT") dartFieldType="String" ;;
        "INTEGER") dartFieldType="int" ;;
        "TIMESTAMP") dartFieldType="DateTime" ;;
    esac


    # --- Inserimento del codice nei file ---

    # File: dao/${moduleNameLower}_dao.dart
    if $isUnique; then
        insert_code "CONSTRAINT_PLACE_HOLDER" "\"UNIQUE(\${${moduleNamePascalCase}DaoModel.${fieldNameCamelCase}Key})\"," "$daoFileName"
    fi
    insert_code "COLUMN_PLACE_HOLDER" "    \"$columnRow\"," "$daoFileName"
    insert_code "COLUMN_NAME_PLACE_HOLDER" "    ${moduleNamePascalCase}DaoModel.${fieldNameCamelCase}Key," "$daoFileName"
    insert_code "COLUMN_VALUE_PLACE_HOLDER" "    ${moduleNameLower}.${fieldNameCamelCase}," "$daoFileName"
    insert_code "COLUMN_UPDATE_PLACE_HOLDER" "        if (${moduleNameLower}.${fieldNameCamelCase} != null) Update${moduleNamePascalCase}DaoModel.${fieldNameCamelCase}Key," "$daoFileName"
    insert_code "COLUMN_UPDATE_VALUE_PLACE_HOLDER" "        if (${moduleNameLower}.${fieldNameCamelCase} != null) ${moduleNameLower}.${fieldNameCamelCase}," "$daoFileName"

    # File: dao/${moduleNameLower}_dao_model.dart
    insert_code "KEY_PLACE_HOLDER" "  static const String ${fieldNameCamelCase}Key = \"${fieldName}\";" "$modelDaoFileName"
    fieldDefinition="final $dartFieldType"
    [[ $isNullable = true ]] && fieldDefinition+="?"
    fieldDefinition+=" ${fieldNameCamelCase};"
    insert_code "FIELD_PLACE_HOLDER" "  $fieldDefinition" "$modelDaoFileName"
    insert_code "CONSTRUCTOR_PLACE_HOLDER" "    required this.${fieldNameCamelCase}," "$modelDaoFileName"

    # File: dao/update_${moduleNameLower}_dao_model.dart
    insert_code "KEY_PLACE_HOLDER" "  static const String ${fieldNameCamelCase}Key = ${moduleNamePascalCase}DaoModel.${fieldNameCamelCase}Key;" "$modelUpdateDaoFileName"
    insert_code "FIELD_PLACE_HOLDER" "  final $dartFieldType? ${fieldNameCamelCase};" "$modelUpdateDaoFileName"
    insert_code "CONSTRUCTOR_PLACE_HOLDER" "    required this.${fieldNameCamelCase}," "$modelUpdateDaoFileName"

    # File: api_request_models/${moduleNameLower}_model.dart
    insert_code "KEY_PLACE_HOLDER" "  static const String ${fieldNameCamelCase}Key = \"${fieldNameCamelCase}\";" "$modelApiRequestFileName"
    insert_code "FIELD_PLACE_HOLDER" "  $fieldDefinition" "$modelApiRequestFileName"
    constructorRow="$fieldNameCamelCase = data[${fieldNameCamelCase}Key],"
    insert_code "CONSTRUCTOR_PLACE_HOLDER" "    $constructorRow" "$modelApiRequestFileName"
    if ! $isNullable && ! $hasDefault; then
        insert_code "REQUIRED_FIELD_PLACE_HOLDER" "    ${fieldNameCamelCase}Key," "$modelApiRequestFileName"
    fi
    insert_code "FIELD_TYPE_PLACE_HOLDER" "    ${fieldNameCamelCase}Key: ${dartFieldType}," "$modelApiRequestFileName"
    toDaoRow="$fieldNameCamelCase: $fieldNameCamelCase,"
    insert_code "TO_DAO_PLACE_HOLDER" "    $toDaoRow" "$modelApiRequestFileName"

    # File: api_request_models/update_${moduleNameLower}_model.dart
    insert_code "KEY_PLACE_HOLDER" "  static const String ${fieldNameCamelCase}Key = ${moduleNamePascalCase}Model.${fieldNameCamelCase}Key;" "$modelApiRequestUpdateFileName"
    insert_code "FIELD_PLACE_HOLDER" "  final $dartFieldType? ${fieldNameCamelCase};" "$modelApiRequestUpdateFileName"
    insert_code "CONSTRUCTOR_PLACE_HOLDER" "    $constructorRow" "$modelApiRequestUpdateFileName"
    insert_code "TO_DAO_PLACE_HOLDER" "    $toDaoRow" "$modelApiRequestUpdateFileName"


    # --- Fine del ciclo ---
    if ! confirm "Vuoi aggiungere un altro campo?"; then
        # Rimuove la virgola finale dall'ultima riga del costruttore nei file API
        lastConstructorString="${constructorRow%,}"
        # Sanifica la stringa per `sed` (escape di '[' e ']')
        searchString=$(echo "$constructorRow" | sed -e 's/\[/\\[/g' -e 's/\]/\\]/g')

        sed -i '' "s/${searchString}/${lastConstructorString}/g" "$modelApiRequestFileName"
        sed -i '' "s/${searchString}/${lastConstructorString}/g" "$modelApiRequestUpdateFileName"
        break
    fi
done

echo "Operazione completata."
