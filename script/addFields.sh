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

    columnRow="\${${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key}"

    read -r -p "Enter field SQL type (supported types: TEXT, INTEGER, TIMESTAMP): " fieldType
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
    if [[ $shouldNullable == "" ]]
    then
      break
    fi

    if [[ $shouldNullable == [Nn] || $shouldNullable == [Nn][Oo] ]]
    then
      isNullable=0
      columnRow="${columnRow} NOT NULL"
    fi

    hasDefault=0
    read -r -p "Has it a default value?: (Y/n) " shouldHasDefault
    if [[ $shouldHasDefault == "" ]]
    then
      break
    fi

    if [[ $shouldHasDefault == [Yy] || $shouldHasDefault == [yY][eE][sS] ]]
    then
      hasDefault=1
      read -r -p "Insert default value" defaultValue
      columnRow="${columnRow} DEFAULT $defaultValue"
    fi

    read -r -p "Has it to be unique?: (Y/n) " shouldUnique
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
    daoRow="static const String ${fieldNameCamelCaseString}Key = \"${fieldName}\";"
    updateDaoRow="static const String ${fieldNameCamelCaseString}Key = ${moduleNamePascalCase}DaoModel.${fieldNameCamelCaseString}Key;"
    updateRow="static const String ${fieldNameCamelCaseString}Key = ${moduleNamePascalCase}Model.${fieldNameCamelCaseString}Key;"
    l="/\/\/KEY_PLACE_HOLDER"
    sed -i '' "$l/i\\
  $daoRow
    " $modelDaoFileName

    l="/\/\/KEY_PLACE_HOLDER"
    sed -i '' "$l/i\\
  $updateDaoRow
    " $modelUpdateDaoFileName

    l="/\/\/KEY_PLACE_HOLDER"
    sed -i '' "$l/i\\
  $row
    " $modelApiRequestFileName

    l="/\/\/KEY_PLACE_HOLDER"
    sed -i '' "$l/i\\
  $updateRow
    " $modelApiRequestUpdateFileName

    row="final"
    updateRow="final"
    if [[ $fieldType == "TEXT" ]]
    then
      dartFieldType="String"
    elif [[ $fieldType == "INTEGER" ]]
    then
      dartFieldType="int"
    elif [[ $fieldType == "TIMESTAMP" ]]
    then
      dartFieldType="DateTime"
    fi

    row="${row} $dartFieldType"
    updateRow="${row}?"

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

    l="/\/\/FIELD_PLACE_HOLDER"
    sed -i '' "$l/i\\
  $row
    " $modelApiRequestFileName

    l="/\/\/FIELD_PLACE_HOLDER"
    sed -i '' "$l/i\\
  $updateRow
    " $modelApiRequestUpdateFileName

    row="required this.${fieldNameCamelCaseString},"
    l="/\/\/CONSTRUCTOR_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $row
    " $modelDaoFileName

    l="/\/\/CONSTRUCTOR_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $row
    " $modelUpdateDaoFileName

    constructorRow="$fieldNameCamelCaseString = data[${fieldNameCamelCaseString}Key],"
    l="/\/\/CONSTRUCTOR_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $constructorRow
    " $modelApiRequestFileName

    l="/\/\/CONSTRUCTOR_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $constructorRow
    " $modelApiRequestUpdateFileName

    if [[ $isNullable == 0 && $hasDefault == 0 ]]
    then
      requiredRow="${fieldNameCamelCaseString}Key,"
      l="/\/\/REQUIRED_FIELD_PLACE_HOLDER"
      sed -i '' "$l/i\\
    $requiredRow
      " $modelApiRequestFileName
    fi

    fieldTypeRow="${fieldNameCamelCaseString}Key: ${dartFieldType},"
    l="/\/\/FIELD_TYPE_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $fieldTypeRow
    " $modelApiRequestFileName

    toDaoRow="$fieldNameCamelCaseString: $fieldNameCamelCaseString,"
    l="/\/\/TO_DAO_PLACE_HOLDER"
    sed -i '' "$l/i\\
    $toDaoRow
    " $modelApiRequestFileName

    sed -i '' "$l/i\\
    $toDaoRow
    " $modelApiRequestUpdateFileName

    read -r -p "Do you want to add another field? (Y/n): " readResult

    if [[ $readResult == [Nn] || $readResult == [Nn][Oo] ]]
    then
      lastConstructorString="${constructorRow%,}"
      searchString=$(echo "$constructorRow" | sed -e 's/\[/\\[/g' -e 's/\]/\\]/g')

      sed -i '' "s/${searchString}/${lastConstructorString}/g" "$modelApiRequestFileName"
      sed -i '' "s/${searchString}/${lastConstructorString}/g" "$modelApiRequestUpdateFileName"
      break
    fi
  done
fi