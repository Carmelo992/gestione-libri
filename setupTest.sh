#!/bin/zsh
rm emile_test.sqlite3
dart run -DDB_NAME=gestione_libri.sqlite3 -DPORT=8182 bin/core/server.dart