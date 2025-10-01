#!/bin/bash
mkdir api_request_models
cd "api_request_models"


moduleName=$1
moduleNameLower=$(echo "$moduleName" | tr '[:upper:]' '[:lower:]')
firstChar=$(echo "${moduleNameLower:0:1}" | tr '[:lower:]' '[:upper:]')
rest="${moduleNameLower:1}"
moduleNamePascalCase="$firstChar$rest"

createModelFile="${moduleNameLower}_model.dart"
updateModelFile="update_${moduleNameLower}_model.dart"
echo $createModelFile
cp ../../../script/template/api_request_model_template $createModelFile
cp ../../../script/template/api_request_update_model_template $updateModelFile

echo $createModelFile
echo $updateModelFile

sed -i '' "s@MODULE_CAMEL@$moduleNamePascalCase@g" $createModelFile
sed -i '' "s@MODULE@$moduleNameLower@g" $createModelFile

sed -i '' "s@MODULE_CAMEL@$moduleNamePascalCase@g" $updateModelFile
sed -i '' "s@MODULE@$moduleNameLower@g" $updateModelFile

