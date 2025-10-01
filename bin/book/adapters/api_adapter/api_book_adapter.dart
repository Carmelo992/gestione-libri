import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/book_model.dart";
import "../../api_request_models/update_book_model.dart";
import "../../dao/book_dao.dart";

part 'api_book_adapter.g.dart';

class ApiBookAdapter {
  ApiBookAdapter();

  @Route.get("/")
  Response _getAllBooks(Request request) {
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
        DatabaseManager.bookDao.getBooks(pagination: withPagination ? PaginationModel(queryParameters).toDao() : null),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertBook(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      BookModel.requiredFields,
      BookModel.fieldTypes,
      BookModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.bookDao.insertBook(BookModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<bookId|[0-9]+>")
  Response _getBook(Request request, String bookId) {
    var resource = DatabaseManager.bookDao.getBook(bookId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<bookId|[0-9]+>")
  Future<Response> _editBook(Request request, String bookId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateBookModel.requiredFields,
      UpdateBookModel.fieldTypes,
      UpdateBookModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateBookModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.bookDao.updateBook(model, bookId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<bookId|[0-9]+>")
  Future<Response> _deleteBook(Request request, String bookId) async {
    if (bookId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.bookDao.deleteBook(bookId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$ApiBookAdapterRouter(this);
}
