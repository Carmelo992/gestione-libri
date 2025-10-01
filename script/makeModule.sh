#!/bin/zsh
set -e

cd ..
cd bin
rm -r $1
mkdir $1
cd $1

echo "  - Creazione adapters..."
../../script/makeAdapters.sh $1

echo "  - Creazione API request models..."
../../script/makeApiRequestModels.sh $1

echo "  - Creazione DAO..."
../../script/makeDao.sh $1

echo "  - Creazione file di export..."
../../script/makeExport.sh $1

echo "  - Aggiornamento database..."
../../script/updateDatabase.sh $1
cd ../..

echo "  - Generazione adapters finali..."
./generateAdapter.sh

echo "✅ Creazione modulo completata con successo."
echo "✍️ Esecuzione del commit..."
git commit -m "Added module $1" .

echo "🎉 Commit eseguito. Modulo '$1' aggiunto correttamente."