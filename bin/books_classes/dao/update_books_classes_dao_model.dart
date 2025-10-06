import '../../core/core.dart';
import 'books_classes_dao_model.dart';

class UpdateBooksClassesDaoModel extends BaseDaoModel {
  static const nameKey = BooksClassesDaoModel.nameKey;
  static const String classIdKey = BooksClassesDaoModel.classIdKey;
  static const String bookIdKey = BooksClassesDaoModel.bookIdKey;

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  String? name;
  final int? classId;
  final int? bookId;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  UpdateBooksClassesDaoModel({
    required this.name,
    required this.classId,
    required this.bookId,
    //CONSTRUCTOR_PLACE_HOLDER
    //Do not remove the line above
  });
}
