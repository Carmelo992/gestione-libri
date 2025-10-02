import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/order_model.dart";
import "../../api_request_models/update_order_model.dart";
import "../../dao/order_dao.dart";

part 'web_order_adapter.g.dart';

class WebOrderAdapter {
  WebOrderAdapter();

  @Route.get("/")
  Response _getAllOrders(Request request) {
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
        DatabaseManager.orderDao.getOrders(
          pagination: withPagination ? PaginationModel(queryParameters).toDao() : null,
        ),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertOrder(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      OrderModel.requiredFields,
      OrderModel.fieldTypes,
      OrderModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.orderDao.insertOrder(OrderModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<orderId|[0-9]+>")
  Response _getOrder(Request request, String orderId) {
    var resource = DatabaseManager.orderDao.getOrder(orderId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<orderId|[0-9]+>")
  Future<Response> _editOrder(Request request, String orderId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateOrderModel.requiredFields,
      UpdateOrderModel.fieldTypes,
      UpdateOrderModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateOrderModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.orderDao.updateOrder(model, orderId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<orderId|[0-9]+>")
  Future<Response> _deleteOrder(Request request, String orderId) async {
    if (orderId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.orderDao.deleteOrder(orderId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$WebOrderAdapterRouter(this);
}
