#!/bin/zsh
rm emile_stage.sqlite3
dart run -DDB_NAME=emile_stage.sqlite3 -DPORT=8080 bin/server.dart &
sleep 8
dart run -DPORT=8080 test/fill_test.dart
kill -9 `ps aux | grep "8080 bin/server.dart" | grep -v grep | awk '{ print $2 }'`