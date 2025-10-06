import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/transaction_model.dart";
import "../../api_request_models/update_transaction_model.dart";
import "../../dao/transaction_dao.dart";
import "../../dao/transaction_dao_model.dart";

part 'api_transaction_adapter.g.dart';

class ApiTransactionAdapter {
  ApiTransactionAdapter();

  @Route.get("/")
  Response _getAllTransactions(Request request) {
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
        DatabaseManager.transactionDao
            .getTransactions(pagination: withPagination ? PaginationModel(queryParameters).toDao() : null)
            .map((e) {
              var row = {...e};
              row.update(TransactionDaoModel.amountKey, (value) => value / 100);
              return row;
            }),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertTransaction(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      TransactionModel.requiredFields,
      TransactionModel.fieldTypes,
      TransactionModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(
        DatabaseManager.transactionDao.insertTransaction(TransactionModel(queryDecoded).toDao()),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<transactionId|[0-9]+>")
  Response _getTransaction(Request request, String transactionId) {
    var resource = DatabaseManager.transactionDao.getTransaction(transactionId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<transactionId|[0-9]+>")
  Future<Response> _editTransaction(Request request, String transactionId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateTransactionModel.requiredFields,
      UpdateTransactionModel.fieldTypes,
      UpdateTransactionModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateTransactionModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.transactionDao.updateTransaction(model, transactionId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<transactionId|[0-9]+>")
  Future<Response> _deleteTransaction(Request request, String transactionId) async {
    if (transactionId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.transactionDao.deleteTransaction(transactionId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$ApiTransactionAdapterRouter(this);
}
