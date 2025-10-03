A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This sample code handles HTTP GET requests to `/` and `/echo/<message>`

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

And then from a second terminal:

```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

And then from a second terminal:

```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

You should see the logging printed in the first terminal:

```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
2021-05-06T15:47:08.392928  0:00:00.001216 GET     [200] /echo/I_love_Dart
```

# TODO

## Update script to create table column

Edit the script `makeDao.sh` in order to be interactive and ask at the user if he wants to add
column.

At the moment the dao is created with only the `name` column.

The final result should be a prompt that ask the column name, the type, if it could be null and the
default value, and some constraints (for example `UNIQUE`).

The changes should be applied to:

- `bin/[module]/dao/[module]_dao.dart` ✅
- `bin/[module]/dao/[module]_dao_model.dart` ✅
- `bin/[module]/dao/update_[module]_dao_model.dart` ✅
- `bin/[module]/api_request_models/[module]_model.dart`
- `bin/[module]/api_request_models/update_[module]_dao_model.dart`