import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/update_year_model.dart";
import "../../api_request_models/year_model.dart";
import "../../dao/year_dao.dart";

part 'web_year_adapter.g.dart';

class WebYearAdapter {
  WebYearAdapter();

  @Route.get("/")
  Response _getAllYears(Request request) {
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
        DatabaseManager.yearDao.getYears(pagination: withPagination ? PaginationModel(queryParameters).toDao() : null),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.post("/")
  Future<Response> _insertYear(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      YearModel.requiredFields,
      YearModel.fieldTypes,
      YearModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.yearDao.insertYear(YearModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<yearId|[0-9]+>")
  Response _getYear(Request request, String yearId) {
    var resource = DatabaseManager.yearDao.getYear(yearId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<yearId|[0-9]+>")
  Future<Response> _editYear(Request request, String yearId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateYearModel.requiredFields,
      UpdateYearModel.fieldTypes,
      UpdateYearModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateYearModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.yearDao.updateYear(model, yearId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<yearId|[0-9]+>")
  Future<Response> _deleteYear(Request request, String yearId) async {
    if (yearId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.yearDao.deleteYear(yearId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$WebYearAdapterRouter(this);
}
