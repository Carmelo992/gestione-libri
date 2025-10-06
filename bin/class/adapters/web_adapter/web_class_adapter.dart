import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/class_model.dart";
import "../../api_request_models/update_class_model.dart";
import "../../dao/class_dao.dart";

part 'web_class_adapter.g.dart';

class WebClassAdapter {
  WebClassAdapter();

  @Route.get("/")
  Response _getAllClasss(Request request) {
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
        DatabaseManager.classDao.getClasss(
          pagination: withPagination ? PaginationModel(queryParameters).toDao() : null,
        ),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertClass(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      ClassModel.requiredFields,
      ClassModel.fieldTypes,
      ClassModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.classDao.insertClass(ClassModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<classId|[0-9]+>")
  Response _getClass(Request request, String classId) {
    var resource = DatabaseManager.classDao.getClass(classId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<classId|[0-9]+>")
  Future<Response> _editClass(Request request, String classId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateClassModel.requiredFields,
      UpdateClassModel.fieldTypes,
      UpdateClassModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateClassModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.classDao.updateClass(model, classId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<classId|[0-9]+>")
  Future<Response> _deleteClass(Request request, String classId) async {
    if (classId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.classDao.deleteClass(classId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$WebClassAdapterRouter(this);
}
