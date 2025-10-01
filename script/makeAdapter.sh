#!/bin/bash

moduleName=$1
moduleNameLower=$(echo "$moduleName" | tr '[:upper:]' '[:lower:]')
firstChar=$(echo "${moduleNameLower:0:1}" | tr '[:lower:]' '[:upper:]')
rest="${moduleNameLower:1}"
moduleNamePascalCase="$firstChar$rest"

target=$2
targetLower=$(echo "$target" | tr '[:upper:]' '[:lower:]')
firstChar=$(echo "${targetLower:0:1}" | tr '[:lower:]' '[:upper:]')
rest="${targetLower:1}"
targetPascalCase="$firstChar$rest"

mkdir "${targetLower}_adapter"
fileName="${targetLower}_${moduleNameLower}_adapter.dart"
echo $fileName
cp ../../../script/template/adapter_template "${targetLower}_adapter/$fileName"
cd "${targetLower}_adapter"

sed -i '' "s@MODULE_CAMEL@$moduleNamePascalCase@g" $fileName
sed -i '' "s@MODULE@$moduleNameLower@g" $fileName

sed -i '' "s@TARGET_CAMEL@$targetPascalCase@g" $fileName
sed -i '' "s@TARGET@$targetLower@g" $fileName
