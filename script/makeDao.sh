#!/bin/bash
mkdir dao
cd "dao"

moduleName=$1
moduleNameLower=$(echo "$moduleName" | tr '[:upper:]' '[:lower:]')
firstChar=$(echo "${moduleNameLower:0:1}" | tr '[:lower:]' '[:upper:]')
rest="${moduleNameLower:1}"
moduleNamePascalCase="$firstChar$rest"

daoFileName="$1_dao.dart"
modelDaoFileName="$1_dao_model.dart"
modelUpdateDaoFileName="update_${moduleNameLower}_dao_model.dart"

echo $daoFileName
echo $modelDaoFileName
echo $modelUpdateDaoFileName

cp ../../../script/template/dao_template $daoFileName
cp ../../../script/template/dao_model_template $modelDaoFileName
cp ../../../script/template/update_dao_model_template $modelUpdateDaoFileName

sed -i '' "s@MODULE_CAMEL@$moduleNamePascalCase@g" $daoFileName
sed -i '' "s@MODULE@$moduleNameLower@g" $daoFileName

sed -i '' "s@MODULE_CAMEL@$moduleNamePascalCase@g" $modelDaoFileName
sed -i '' "s@MODULE@$moduleNameLower@g" $modelDaoFileName

sed -i '' "s@MODULE_CAMEL@$moduleNamePascalCase@g" $modelUpdateDaoFileName
sed -i '' "s@MODULE@$moduleNameLower@g" $modelUpdateDaoFileName

