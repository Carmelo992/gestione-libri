import '../../core/core.dart';

class BooksClassesDaoModel extends BaseDaoModel {
  static const nameKey = "name";
  static const String classIdKey = "class_id";
  static const String bookIdKey = "book_id";
  static const String toBuyKey = "to_buy";
  static const String newVersionKey = "new_version";
  static const String mandatoryKey = "mandatory";

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String name;
  final int classId;
  final int bookId;
  final bool toBuy, newVersion, mandatory;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  BooksClassesDaoModel({
    required this.name,
    required this.classId,
    required this.bookId,
    required this.toBuy,
    required this.newVersion,
    required this.mandatory,
    //CONSTRUCTOR_PLACE_HOLDER
    //Do not remove the line above
  });
}
