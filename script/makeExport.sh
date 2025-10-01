#!/bin/bash

moduleName=$1
moduleNameLower=$(echo "$moduleName" | tr '[:upper:]' '[:lower:]')
firstChar=$(echo "${moduleNameLower:0:1}" | tr '[:lower:]' '[:upper:]')
rest="${moduleNameLower:1}"
moduleNamePascalCase="$firstChar$rest"

exportFileName="${moduleNameLower}.dart"

echo $exportFileName

cp ../../script/template/export_template $exportFileName


sed -i '' "s@MODULE_CAMEL@$moduleNamePascalCase@g" $exportFileName
sed -i '' "s@MODULE@$moduleNameLower@g" $exportFileName
