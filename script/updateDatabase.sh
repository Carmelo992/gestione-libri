#!/bin/bash

moduleName=$1
moduleNameLower=$(echo "$moduleName" | tr '[:upper:]' '[:lower:]')
firstChar=$(echo "${moduleNameLower:0:1}" | tr '[:lower:]' '[:upper:]')
rest="${moduleNameLower:1}"
moduleNamePascalCase="$firstChar$rest"

cd ../core
l="/\/\/NEW_MODULE_PATH_PLACE_HOLDER"
newImportLine="import '..\/$moduleNameLower\/$moduleNameLower.dart';"

sed -i '' "$l/i\\
$newImportLine
" database.dart

l="/\/\/NEW_MODULE_DAO_PLACE_HOLDER"
newImportLine=$'\t'"static ${moduleNamePascalCase}Dao ${moduleNameLower}Dao = ${moduleNamePascalCase}Dao(db);"

sed -i '' "$l/i\\
$newImportLine
" database.dart

l="/\/\/NEW_MODULE_MIGRATION_PLACE_HOLDER"
newImportLine=$'\t\t\t'"${moduleNamePascalCase}Dao.migrate(newDbVersion);"

sed -i '' "$l/i\\
$newImportLine
" database.dart

l="/\/\/NEW_MODULE_CREATE_TABLE_PLACE_HOLDER"
newImportLine=$'\t\t'"db.execute(createTable(${moduleNamePascalCase}Dao.tableName, ${moduleNamePascalCase}Dao.tableColumns));"

sed -i '' "$l/i\\
$newImportLine
" database.dart