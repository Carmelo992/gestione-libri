import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/update_website_model.dart";
import "../../api_request_models/website_model.dart";
import "../../dao/website_dao.dart";

part 'web_website_adapter.g.dart';

class WebWebsiteAdapter {
  WebWebsiteAdapter();

  @Route.get("/")
  Response _getAllWebsites(Request request) {
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
        DatabaseManager.websiteDao.getWebsites(
          pagination: withPagination ? PaginationModel(queryParameters).toDao() : null,
        ),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertWebsite(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      WebsiteModel.requiredFields,
      WebsiteModel.fieldTypes,
      WebsiteModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.websiteDao.insertWebsite(WebsiteModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<websiteId|[0-9]+>")
  Response _getWebsite(Request request, String websiteId) {
    var resource = DatabaseManager.websiteDao.getWebsite(websiteId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<websiteId|[0-9]+>")
  Future<Response> _editWebsite(Request request, String websiteId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateWebsiteModel.requiredFields,
      UpdateWebsiteModel.fieldTypes,
      UpdateWebsiteModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateWebsiteModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.websiteDao.updateWebsite(model, websiteId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<websiteId|[0-9]+>")
  Future<Response> _deleteWebsite(Request request, String websiteId) async {
    if (websiteId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.websiteDao.deleteWebsite(websiteId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$WebWebsiteAdapterRouter(this);
}
