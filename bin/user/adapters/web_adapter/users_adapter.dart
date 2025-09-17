import 'dart:convert';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../database.dart';
import '../../../logger.dart';
import '../../../manager/mail_manager.dart';
import '../../../manager/validation_model_manager.dart';
import '../../../request_models/pagination_model.dart';
import '../../../request_models/response_model.dart';
import '../../../request_models/user/register_user_model.dart';
import '../../../request_models/user/update_user_model.dart';
import '../../../request_models/user/user_model.dart';
import '../../../strings.dart';

part 'users_adapter.g.dart';

class UserAdapter {
  UserAdapter();

  @Route.get("/")
  Response _getAllUsers(Request request) {
    var queryParameters = request.url.queryParameters;

    bool withPagination =
        queryParameters[PaginationModel.limitKey] != null && queryParameters[PaginationModel.offsetKey] != null;
    ValidationError? validationError;
    if (withPagination) {
      validationError = ValidationModelsManager.validate(
        queryParameters,
        PaginationModel.requiredFields,
        PaginationModel.fieldTypes,
        PaginationModel.validateField,
      );
    }

    return switch (validationError) {
      null => CustomResponse.ok(
        DatabaseManager.userDao.getUsers(pagination: withPagination ? PaginationModel(queryParameters).toDao() : null),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertUser(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UserModel.requiredFields,
      UserModel.fieldTypes,
      UserModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.userDao.insertUser(UserModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<userId|[0-9]+>")
  Response _getUser(Request request, String userId) {
    var resource = DatabaseManager.userDao.getUser(userId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<userId|[0-9]+>")
  Future<Response> _editUser(Request request, String userId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateResourceModel.requiredFields,
      UpdateResourceModel.fieldTypes,
      UpdateResourceModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateResourceModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.userDao.updateUser(model, userId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<userId|[0-9]+>")
  Future<Response> _deleteUser(Request request, String userId) async {
    if (userId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.userDao.deleteUser(userId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.put("/register")
  Future<Response> _registerUser(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      RegisterUserModel.requiredFields,
      RegisterUserModel.fieldTypes,
      RegisterUserModel.validateField,
    );

    var user = DatabaseManager.userDao.getUserByEmail(queryDecoded[UserModel.emailKey]);
    if (user != null) {
      return CustomResponse(405);
    }

    return switch (validationError) {
      null => () async {
        String password = Random().nextInt(pow(10, 8).toInt()).toString().padLeft(8, "0");
        queryDecoded[UserModel.passwordKey] = password;
        var user = UserModel(queryDecoded);
        var addedUser = DatabaseManager.userDao.insertUser(user.toDao());

        bool mailSent = await MailManager.sendNewUserEmail(user.fullName, user.email, user.password);
        if (mailSent) {
          return CustomResponse.ok(addedUser);
        } else {
          return CustomResponse(202, body: addedUser);
        }
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$UserAdapterRouter(this);

  void generateAdmin() {
    DatabaseManager.userDao.insertAdmin();
  }
}
