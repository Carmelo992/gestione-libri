A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

# TODO for script

- Add foreign key constraints
- Handle module with `_` in the name ✅
- Add support for BOOLEAN SQL type

# TODO for project

- Create city module ✅
- Create school module ✅
- Create class module ✅
- Create book module ✅
- Create book - class relationship ✅
- Create order module ✅
- Create order - book relationship
- Create year module ✅
- Create site module ✅
- Create student module ✅
- Create transaction module ✅