#!/bin/zsh
rm emile_test.sqlite3
dart run -DDB_NAME=emil_test.sqlite3 -DPORT=8182 bin/server.dart