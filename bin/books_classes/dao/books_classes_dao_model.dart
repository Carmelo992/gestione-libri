import '../../core/core.dart';

class BooksClassesDaoModel extends BaseDaoModel {
  static const nameKey = "name";
  static const String classIdKey = "class_id";
  static const String bookIdKey = "book_id";

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String name;
  final int classId;
  final int bookId;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  BooksClassesDaoModel({
    required this.name,
    required this.classId,
    required this.bookId,
    //CONSTRUCTOR_PLACE_HOLDER
    //Do not remove the line above
  });
}
