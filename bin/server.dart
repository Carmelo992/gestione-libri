import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import "adapter/service_adapter/service_adapter.dart";
import 'database.dart';
import 'logger.dart';
import "manager/jwt_manager.dart";
import "manager/reset_password_manager.dart";
import "request_models/response_model.dart";
import "user/adapters/web_adapter/users_adapter.dart";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, PUT, POST, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "*",
};

Response? _options(Request request) => (request.method == "OPTIONS") ? Response.ok(null, headers: corsHeaders) : null;

Response _cors(Response response) => response.change(headers: corsHeaders);

final _corsHeaderMiddleware = createMiddleware(requestHandler: _options, responseHandler: _cors);

void main() async {
  const dbNameEnv = String.fromEnvironment("DB_NAME");
  const portEnv = int.fromEnvironment("PORT", defaultValue: 51006);
  String? dbName = dbNameEnv.isEmpty ? null : dbNameEnv;
  int port = portEnv;

  Logger.startup();

  DatabaseManager.openDatabase(dbName);
  DatabaseManager.createDatabaseTable();
  DatabaseManager.handleMigration();

  JwtManager.startCleanJob();
  ResetPasswordManager.startCleanJob();

  try {
    UserAdapter().generateAdmin();
  } catch (e) {
    //ignored
  }
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests(logger: (message, isError) => isError ? Logger.error(message) : Logger.info(message)))
      .addMiddleware(_corsHeaderMiddleware)
      .addMiddleware(checkAuth)
      .addHandler(ServiceAdapter().handler);

  final server = await serve(handler, ip, port);
  Logger.log('Server listening on port ${server.port}');
}

Middleware checkAuth = createMiddleware(
  requestHandler: (request) {
    const apiRootKey = "/api/";
    const authRootKey = "/auth/";
    const webRootKey = "/web/";

    var path = request.requestedUri.path;
    if (!path.startsWith(apiRootKey) && !path.startsWith(authRootKey) && !path.startsWith(webRootKey)) {
      return null;
    }
    if (ApiWithCustomJwtHandling.values.where((element) => !element.jwtRequired).map((e) => e.apiPath).contains(path)) {
      return null;
    }
    var token = JwtManager.getJwtFromHeader(request.headers);
    if (token == null) {
      return CustomResponse.unauthorized();
    }

    if (path == ApiWithCustomJwtHandling.renewToken.apiPath) {
      if (JwtManager.validateRefreshToken(token)) {
        return null;
      } else {
        return CustomResponse.unauthorized();
      }
    }

    if (path == ApiWithCustomJwtHandling.resetPassword.apiPath) {
      if (JwtManager.validateResetPasswordToken(token)) {
        return null;
      } else {
        return CustomResponse.unauthorized();
      }
    }

    if (!JwtManager.validateAccessToken(
      token,
      path.startsWith(webRootKey),
      ignoreCheckUserRole: path.startsWith(authRootKey) || path.startsWith(webRootKey),
    )) {
      return CustomResponse.unauthorized();
    }
    return null;
  },
);

enum ApiWithCustomJwtHandling {
  login,
  resetCode,
  renewToken,
  resetPassword;

  String get apiPath => switch (this) {
    ApiWithCustomJwtHandling.login => "/auth/login",
    ApiWithCustomJwtHandling.resetCode => "/auth/resetCode",
    ApiWithCustomJwtHandling.renewToken => "/auth/renewToken",
    ApiWithCustomJwtHandling.resetPassword => "/auth/resetPassword",
  };

  bool get jwtRequired => switch (this) {
    ApiWithCustomJwtHandling.login || ApiWithCustomJwtHandling.resetCode => false,
    ApiWithCustomJwtHandling.renewToken || ApiWithCustomJwtHandling.resetPassword => true,
  };
}
