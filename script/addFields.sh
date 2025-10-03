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
modelUpdateDaoFileName="api_request_models/update_${moduleNameLower}_model.dart"

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
    echo "$fieldNameCamelCaseString" # Output: provaUnoAncora

    columnRow="\${${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key}"

    read -r -p "Enter field SQL type (supported types: TEXT, INTEGER, TIMESTAMP): " fieldType
    if [[ fieldType == "" ]]
    then
      break
    fi

    columnRow="$columnRow $fieldType"

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

    updateRow="if (${moduleNameLower}.${fieldNameCamelCaseString} != null) Update${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key,"
    l="/\/\/COLUMN_UPDATE_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $updateRow
    " $daoFileName

    updateRow="if (${moduleNameLower}.${fieldNameCamelCaseString} != null) ${moduleNameLower}.${fieldNameCamelCaseString},"
    l="/\/\/COLUMN_UPDATE_VALUE_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $updateRow
    " $daoFileName


    read -r -p "Do you want to add another field? (Y/n): " readResult

    if [[ $readResult == [Nn] || $readResult == [Nn][Oo] ]]
    then
      break
    fi

  done
fi