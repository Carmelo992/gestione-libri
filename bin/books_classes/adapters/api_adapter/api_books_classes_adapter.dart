import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/books_classes_model.dart";
import "../../api_request_models/update_books_classes_model.dart";
import "../../dao/books_classes_dao.dart";

part 'api_books_classes_adapter.g.dart';

class ApiBooksClassesAdapter {
  ApiBooksClassesAdapter();

  @Route.get("/")
  Response _getAllBooksClasses(Request request) {
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
        DatabaseManager.booksClassesDao.getBooks_classess(
          pagination: withPagination ? PaginationModel(queryParameters).toDao() : null,
        ),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertBooksClasses(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      BooksClassesModel.requiredFields,
      BooksClassesModel.fieldTypes,
      BooksClassesModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(
        DatabaseManager.booksClassesDao.insertBooks_classes(BooksClassesModel(queryDecoded).toDao()),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<booksClassesId|[0-9]+>")
  Response _getBooksClasses(Request request, String booksClassesId) {
    var resource = DatabaseManager.booksClassesDao.getBooksClasses(booksClassesId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<booksClassesId|[0-9]+>")
  Future<Response> _editBooksClasses(Request request, String booksClassesId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateBooksClassesModel.requiredFields,
      UpdateBooksClassesModel.fieldTypes,
      UpdateBooksClassesModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateBooksClassesModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.booksClassesDao.updateBooksClasses(model, booksClassesId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<booksClassesId|[0-9]+>")
  Future<Response> _deleteBooksClasses(Request request, String booksClassesId) async {
    if (booksClassesId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.booksClassesDao.deleteBooksClasses(booksClassesId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$ApiBooksClassesAdapterRouter(this);
}
