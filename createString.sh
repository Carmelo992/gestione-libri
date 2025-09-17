#!/bin/bash

echo Definint new string...

while true; do
  read -r -p "Insert key, it must be lowerCamelCased: " key
  read -r -p "Insert method name, it must be lowerCamelCased: " methodName
  read -r -p "Insert translation [en]: " translation

  l="//STRING_KEY"
  a="\t${key},\n//STRING_KEY"

  sed -i '' "s|$l|$a|g" bin/strings.dart

  l="//STRING_METHOD"
  a="\n\tstatic String ${methodName}([String? lang]) => _get(StringKey.${key}, lang);\n//STRING_METHOD"

  sed -i '' "s|$l|$a|g" bin/strings.dart

  l="//STRING_MAP_KEY"
  a="\t\tStringKey.${key}: {\"en\": \"${translation}\"},\n//STRING_MAP_KEY"

  sed -i '' "s|$l|$a|g" bin/strings.dart


  read -r -p "Do you want to create string? (Y/n): " readResult

  if [[ $readResult == [Nn] || $readResult == [Nn][Oo] ]]
  then
    break
  fi
done