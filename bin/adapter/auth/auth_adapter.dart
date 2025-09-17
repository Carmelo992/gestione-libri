import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../database.dart';
import '../../logger.dart';
import '../../manager/jwt_manager.dart';
import '../../manager/reset_password_manager.dart';
import '../../manager/validation_model_manager.dart';
import '../../request_models/auth/change_password_model.dart';
import '../../request_models/auth/reset_code_model.dart';
import '../../request_models/auth/reset_password_model.dart';
import '../../request_models/auth/auth_model.dart';
import '../../request_models/response_model.dart';
import '../../request_models/user/user_model.dart';
import '../../strings.dart';

part 'auth_adapter.g.dart';

class AuthAdapter {
  AuthAdapter();

  @Route.get("/")
  Response _getProfile(Request request) {
    return CustomResponse.badRequest(body: {"temp": "not implemented"});
  }

  @Route.put("/")
  Future<Response> _editProfile(Request request) async {
    return CustomResponse.badRequest(body: {"temp": "not implemented"});
  }

  @Route.post("/login")
  Future<Response> _login(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      AuthModel.requiredFields,
      AuthModel.fieldTypes,
      AuthModel.validateField,
    );
    if (validationError != null) {
      return CustomResponse.badRequest(body: validationError.bodyJson);
    }
    var resource = DatabaseManager.userDao.login(queryDecoded[AuthModel.emailKey]);
    if (resource != null) {
      try {
        bool validPassword = BCrypt.checkpw(queryDecoded[AuthModel.passwordKey], resource[AuthModel.passwordKey]);
        if (validPassword) {
          var userId = resource[DatabaseManager.idKey];

          var isAdmin = resource[UserModel.isAdminKey] == 1;
          var appWebKey = "X-APP-WEB";
          bool? isWeb = request.headers[appWebKey] != null ? bool.tryParse(request.headers[appWebKey]!) : null;
          if (isWeb == null) {
            Logger.error("Missing X-APP-WEB parameter");
            return CustomResponse.unauthorized();
          }

          if (!isWeb && isAdmin) {
            return CustomResponse.unauthorized();
          }
          return CustomResponse.ok(
            {
              ...resource,
              JwtManager.tokenKey: JwtManager.createAccessToken(userId, resource[UserModel.isAdminKey] == 1),
              JwtManager.refreshTokenKey: JwtManager.createRefreshToken(userId, resource[UserModel.isAdminKey] == 1),
            }..remove(AuthModel.passwordKey),
          );
        } else {
          Logger.info(queryDecoded);
          return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.wrongCredentials()});
        }
      } catch (e) {
        Logger.info(queryDecoded);
        Logger.error(e.toString());
        return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.wrongCredentials()});
      }
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.post("/logout")
  Future<Response> _logout(Request request) async {
    var token = JwtManager.getJwtFromHeader(request.headers);
    if (token == null) {
      return CustomResponse.unauthorized();
    }
    JwtManager.invalidateJwt(token);
    return CustomResponse.ok(null);
  }

  @Route.post("/renewToken")
  Future<Response> _renewToken(Request request) async {
    var accessToken = JwtManager.renewToken(request.headers, true);
    var refreshToken = JwtManager.renewToken(request.headers, false);
    if (accessToken == null || refreshToken == null) {
      return CustomResponse.unauthorized();
    }

    return CustomResponse.ok({JwtManager.tokenKey: accessToken, JwtManager.refreshTokenKey: refreshToken});
  }

  @Route.post("/resetCode")
  Future<Response> _resetCode(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      ResetCodeModel.requiredFields,
      ResetCodeModel.fieldTypes,
      ResetCodeModel.validateField,
    );
    if (validationError != null) {
      return CustomResponse.badRequest(body: validationError.bodyJson);
    }

    String email = queryDecoded[UserModel.emailKey];
    var userData = DatabaseManager.userDao.getUserByEmail(email);
    if (userData == null) {
      return CustomResponse.notFound();
    }

    var userId = userData[DatabaseManager.idKey];
    var isAdmin = userData[JwtManager.isAdminKey] == 1;

    String fullName = "${userData[UserModel.firstNameKey]} ${userData[UserModel.lastNameKey]}";
    var code = await ResetPasswordManager.code(userId, email, fullName);
    if (code != null) {
      return CustomResponse.ok({JwtManager.tokenKey: JwtManager.createResetPasswordToken(userId, isAdmin)});
    }
    return CustomResponse(422, body: {StringsManager.error(): StringsManager.resetCodePasswordError()});
  }

  @Route.post("/resetPassword")
  Future<Response> _resetPassword(Request request) async {
    var userId = JwtManager.getUserIdFromHeader(request.headers);
    if (userId == null) {
      return CustomResponse.unauthorized();
    }

    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      ResetPasswordModel.requiredFields,
      ResetPasswordModel.fieldTypes,
      ResetPasswordModel.validateField,
    );
    if (validationError != null) {
      return CustomResponse.badRequest(body: validationError.bodyJson);
    }

    var model = ResetPasswordModel.fromMap(queryDecoded);

    bool isCodeValid = ResetPasswordManager.validate(userId, model.code);

    if (isCodeValid) {
      DatabaseManager.userDao.updatePassword(userId.toString(), model.password);
      return CustomResponse.ok({});
    } else {
      return CustomResponse.forbidden();
    }
  }

  @Route.post("/changePassword")
  Future<Response> _changePassword(Request request) async {
    var userId = JwtManager.getUserIdFromHeader(request.headers);
    if (userId == null) {
      return CustomResponse.unauthorized();
    }

    var userData = DatabaseManager.userDao.getUser(userId.toString());
    if (userData == null) {
      return CustomResponse.notFound();
    }

    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      ChangePasswordModel.requiredFields,
      ChangePasswordModel.fieldTypes,
      ChangePasswordModel.validateField,
    );
    if (validationError != null) {
      return CustomResponse.badRequest(body: validationError.bodyJson);
    }

    var model = ChangePasswordModel.fromMap(queryDecoded);

    bool areCredentialsValid = BCrypt.checkpw(model.oldPassword, userData[UserModel.passwordKey]);

    if (areCredentialsValid) {
      DatabaseManager.userDao.updatePassword(userId.toString(), model.newPassword);
      return CustomResponse.ok({});
    } else {
      return CustomResponse.forbidden();
    }
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$AuthAdapterRouter(this);
}
