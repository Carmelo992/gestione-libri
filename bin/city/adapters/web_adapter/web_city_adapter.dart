import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/city_model.dart";
import "../../api_request_models/update_city_model.dart";
import "../../dao/city_dao.dart";

part 'web_city_adapter.g.dart';

class WebCityAdapter {
  WebCityAdapter();

  @Route.get("/")
  Response _getAllCities(Request request) {
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
        DatabaseManager.cityDao.getCities(pagination: withPagination ? PaginationModel(queryParameters).toDao() : null),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertCity(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      CityModel.requiredFields,
      CityModel.fieldTypes,
      CityModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.cityDao.insertCity(CityModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<cityId|[0-9]+>")
  Response _getCity(Request request, String cityId) {
    var resource = DatabaseManager.cityDao.getCity(cityId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<cityId|[0-9]+>")
  Future<Response> _editCity(Request request, String cityId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateCityModel.requiredFields,
      UpdateCityModel.fieldTypes,
      UpdateCityModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateCityModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.cityDao.updateCity(model, cityId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<cityId|[0-9]+>")
  Future<Response> _deleteCity(Request request, String cityId) async {
    if (cityId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.cityDao.deleteCity(cityId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$WebCityAdapterRouter(this);
}
