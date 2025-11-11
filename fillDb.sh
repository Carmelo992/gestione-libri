#!/bin/zsh
rm gestione_libri.sqlite3
dart run -DDB_NAME=gestione_libri.sqlite3 -DPORT=8080 bin/core/server.dart &
sleep 8
dart run -DPORT=8080 test/fill_test.dart
kill -9 `ps aux | grep "8080 bin/core/server.dart" | grep -v grep | awk '{ print $2 }'`