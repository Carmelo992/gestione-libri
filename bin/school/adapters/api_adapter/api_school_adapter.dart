import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/school_model.dart";
import "../../api_request_models/update_school_model.dart";
import "../../dao/school_dao.dart";

part 'api_school_adapter.g.dart';

class ApiSchoolAdapter {
  ApiSchoolAdapter();

  @Route.get("/")
  Response _getAllSchools(Request request) {
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
        DatabaseManager.schoolDao.getSchools(
          pagination: withPagination ? PaginationModel(queryParameters).toDao() : null,
        ),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertSchool(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      SchoolModel.requiredFields,
      SchoolModel.fieldTypes,
      SchoolModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.schoolDao.insertSchool(SchoolModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<schoolId|[0-9]+>")
  Response _getSchool(Request request, String schoolId) {
    var resource = DatabaseManager.schoolDao.getSchool(schoolId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<schoolId|[0-9]+>")
  Future<Response> _editSchool(Request request, String schoolId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateSchoolModel.requiredFields,
      UpdateSchoolModel.fieldTypes,
      UpdateSchoolModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateSchoolModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.schoolDao.updateSchool(model, schoolId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<schoolId|[0-9]+>")
  Future<Response> _deleteSchool(Request request, String schoolId) async {
    if (schoolId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.schoolDao.deleteSchool(schoolId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$ApiSchoolAdapterRouter(this);
}
