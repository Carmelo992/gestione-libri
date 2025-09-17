dart pub get --offline
sh ./generateAdapter.sh
rm -rf output
mkdir -p output
dart compile exe -o output/server bin/server.dart -DDB_NAME=emile_exe.sqlite3 -DPORT=51006 -DMAILJET_SECRET_KEY=d0b6751978c91859a07881f755e593c1 -DMAILJET_API_KEY=ccf193fb2ba60f988bd4952d14e51c53
