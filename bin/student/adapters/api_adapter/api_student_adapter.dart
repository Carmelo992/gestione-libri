import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../core/core.dart';
import '../../../manager/validation_model_manager.dart';
import "../../api_request_models/student_model.dart";
import "../../api_request_models/update_student_model.dart";
import "../../dao/student_dao.dart";

part 'api_student_adapter.g.dart';

class ApiStudentAdapter {
  ApiStudentAdapter();

  @Route.get("/")
  Response _getAllStudents(Request request) {
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
        DatabaseManager.studentDao.getStudents(
          pagination: withPagination ? PaginationModel(queryParameters).toDao() : null,
        ),
      ),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.put("/")
  Future<Response> _insertStudent(Request request) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      StudentModel.requiredFields,
      StudentModel.fieldTypes,
      StudentModel.validateField,
    );
    return switch (validationError) {
      null => CustomResponse.ok(DatabaseManager.studentDao.insertStudent(StudentModel(queryDecoded).toDao())),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.get("/<studentId|[0-9]+>")
  Response _getStudent(Request request, String studentId) {
    var resource = DatabaseManager.studentDao.getStudent(studentId);
    if (resource != null) {
      return CustomResponse.ok(resource);
    } else {
      return CustomResponse.notFound();
    }
  }

  @Route.put("/<studentId|[0-9]+>")
  Future<Response> _editStudent(Request request, String studentId) async {
    String query = await request.readAsString();
    Map<String, dynamic> queryDecoded = jsonDecode(query);
    if (queryDecoded.isEmpty) {
      Logger.log(StringsManager.missingDataError());
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.missingDataError()});
    }

    var validationError = ValidationModelsManager.validate(
      queryDecoded,
      UpdateStudentModel.requiredFields,
      UpdateStudentModel.fieldTypes,
      UpdateStudentModel.validateField,
    );
    return switch (validationError) {
      null => () {
        var model = UpdateStudentModel(queryDecoded).toDao();
        var updatedClient = DatabaseManager.studentDao.updateStudent(model, studentId);
        if (updatedClient == null) {
          return CustomResponse.notFound();
        }
        return CustomResponse.ok(updatedClient);
      }.call(),
      _ => CustomResponse.badRequest(body: validationError.bodyJson),
    };
  }

  @Route.delete("/<studentId|[0-9]+>")
  Future<Response> _deleteStudent(Request request, String studentId) async {
    if (studentId.isEmpty) {
      return CustomResponse.badRequest(body: {StringsManager.error(): StringsManager.invalidId});
    }
    bool success = DatabaseManager.studentDao.deleteStudent(studentId);
    if (success) {
      return CustomResponse.ok(null);
    }
    return CustomResponse.notFound();
  }

  @Route.all("/<ignored|.*>")
  Response notFound(Request request) => CustomResponse.notFound();

  Router get router => _$ApiStudentAdapterRouter(this);
}
