#!/bin/bash

moduleName=$1
moduleNameLower=$(echo "$moduleName" | tr '[:upper:]' '[:lower:]')
firstChar=$(echo "${moduleNameLower:0:1}" | tr '[:lower:]' '[:upper:]')
rest="${moduleNameLower:1}"
moduleNamePascalCase="$firstChar$rest"

daoFileName="dao/${moduleNameLower}_dao.dart"
modelDaoFileName="dao/${moduleNameLower}_dao_model.dart"
modelUpdateDaoFileName="dao/update_${moduleNameLower}_dao_model.dart"
modelApiRequestFileName="api_request_models/${moduleNameLower}_model.dart"
modelApiRequestUpdateFileName="api_request_models/update_${moduleNameLower}_model.dart"

read -r -p "Do you want to add a custom fields this version? (Y/n): " readResult
if [[ $readResult == [Yy] || $readResult == [yY][eE][sS] ]]
then

  while true; do

    read -r -p "Enter field name (ex. custom_field): " fieldName
    if [[ fieldName == "" ]]
    then
      break
    fi

    fieldNameCamelCaseString=$(echo "$fieldName" | awk -F_ '{printf "%s", $1; for(i=2; i<=NF; i++) {printf "%s%s", toupper(substr($i,1,1)), substr($i,2)}; printf "\n"}')
    echo "$fieldNameCamelCaseString"

    columnRow="\${${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key}"

    read -r -p "Enter field SQL type (supported types: TEXT, INTEGER, TIMESTAMP): " fieldType
    echo $filedType
    if [[ fieldType == "" || ($fieldType != "TEXT" && $fieldType != "INTEGER" && $fieldType != "TIMESTAMP") ]]
    then
      break
    fi

    columnRow="$columnRow $fieldType"
    if [[ $fieldType == "TIMESTAMP" ]]
    then
      columnRow="$columnRow DATETIME"
    fi

    isNullable=1
    read -r -p "Has it to be nullable?: (Y/n) " shouldNullable
    echo "nullable -> $shouldNullable"
    if [[ $shouldNullable == "" ]]
    then
      break
    fi

    if [[ $shouldNullable == [Nn] || $shouldNullable == [Nn][Oo] ]]
    then
      isNullable=0
      columnRow="${columnRow} NOT NULL"
    fi

    read -r -p "Has it a default value?: (Y/n) " shouldHasDefault
    echo "default -> $shouldHasDefault"
    if [[ $shouldHasDefault == "" ]]
    then
      break
    fi

    if [[ $shouldHasDefault == [Yy] || $shouldHasDefault == [yY][eE][sS] ]]
    then
      read -r -p "Insert default value" defaultValue
      echo "defaultValue -> $defaultValue"
      columnRow="${columnRow} DEFAULT $defaultValue"
    fi

    read -r -p "Has it to be unique?: (Y/n) " shouldUnique
    echo "shouldUnique -> $shouldUnique"
    if [[ $shouldUnique == "" ]]
    then
      break
    fi

    if [[ $shouldUnique == [Yy] || $shouldUnique == [yY][eE][sS] ]]
    then
      updateRow="\"UNIQUE(\${${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key})\","
      l="/\/\/CONSTRAINT_PLACE_HOLDER"
      sed -i '' "$l/i\\
      $updateRow
      " $daoFileName
    fi

    l="/\/\/COLUMN_PLACE_HOLDER"
    sed -i '' "$l/i\\
    \"$columnRow\"
    " $daoFileName

    updateRow="${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key,"
    l="/\/\/COLUMN_NAME_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $updateRow
    " $daoFileName

    updateRow="${moduleNameLower}.${fieldNameCamelCaseString},"
    l="/\/\/COLUMN_VALUE_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $updateRow
    " $daoFileName

    updateRow=$'\t\t'"if (${moduleNameLower}.${fieldNameCamelCaseString} != null) Update${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key,"
    l="/\/\/COLUMN_UPDATE_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $updateRow
    " $daoFileName

    updateRow=$'\t\t'"if (${moduleNameLower}.${fieldNameCamelCaseString} != null) ${moduleNameLower}.${fieldNameCamelCaseString},"
    l="/\/\/COLUMN_UPDATE_VALUE_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $updateRow
    " $daoFileName

    row="static const String ${fieldNameCamelCaseString}Key = \"${fieldNameCamelCaseString}\";"
    updateRow="static const String ${fieldNameCamelCaseString}Key = ${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key;"
    l="/\/\/KEY_PLACE_HOLDER"
    sed -i '' "$l/i\\
  $row
    " $modelDaoFileName

    l="/\/\/KEY_PLACE_HOLDER"
    sed -i '' "$l/i\\
  $updateRow
    " $modelUpdateDaoFileName

    #final String name;
    row="final"
    updateRow="final"
    if [[ $fieldType == "TEXT" ]]
    then
      row="${row} String"
      updateRow="${updateRow} String?"
    elif [[ $fieldType == "INTEGER" ]]
    then
      row="${row} int"
      updateRow="${updateRow} int?"
    elif [[ $fieldType == "TIMESTAMP" ]]
    then
      row="${row} DateTime"
      updateRow="${updateRow} DateTime?"
    fi

    if [[ $isNullable == 1 ]]
    then
      row="${row}?"
    fi

    row="${row} ${fieldNameCamelCaseString};"
    updateRow="${updateRow} ${fieldNameCamelCaseString};"
    l="/\/\/FIELD_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $row
    " $modelDaoFileName

    l="/\/\/FIELD_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $updateRow
    " $modelUpdateDaoFileName

    #required this.name,
    row="required this.${fieldNameCamelCaseString},"
    l="/\/\/CONSTRUCTOR_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $row
    " $modelDaoFileName

    l="/\/\/CONSTRUCTOR_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $row
    " $modelUpdateDaoFileName

    read -r -p "Do you want to add another field? (Y/n): " readResult

    if [[ $readResult == [Nn] || $readResult == [Nn][Oo] ]]
    then
      break
    fi

  done
fi