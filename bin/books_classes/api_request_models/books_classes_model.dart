import '../../core/core.dart';
import '../dao/books_classes_dao_model.dart';

class BooksClassesModel extends BaseAdapterModel<BooksClassesDaoModel> {
  static const nameKey = "name";
  static const String classIdKey = "classId";
  static const String bookIdKey = "bookId";
  static const String toBuyKey = "toBuy";
  static const String newVersionKey = "newVersion";
  static const String mandatoryKey = "mandatory";

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String name;
  final int classId;
  final int bookId;
  final bool toBuy, newVersion, mandatory;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  BooksClassesModel(Map<String, dynamic> data, [String? booksClassesId])
    : name = data[nameKey],
      classId = data[classIdKey],
      bookId = data[bookIdKey],
      toBuy = data[toBuyKey],
      newVersion = data[newVersionKey],
      mandatory = data[mandatoryKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [
    nameKey,
    classIdKey,
    bookIdKey,
    toBuyKey,
    newVersionKey,
    mandatoryKey,
    //REQUIRED_FIELD_PLACE_HOLDER
    //Do not remove the line above
  ];

  static Map<String, Type> get fieldTypes => {
    nameKey: String,
    classIdKey: int,
    bookIdKey: int,
    toBuyKey: bool,
    newVersionKey: bool,
    mandatoryKey: bool,
    //FIELD_TYPE_PLACE_HOLDER
    //Do not remove the line above
  };

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      //TODO add custom validation rule here
      _ => null,
    };
  }

  @override
  BooksClassesDaoModel toDao() => BooksClassesDaoModel(
    name: name,
    classId: classId,
    bookId: bookId,
    toBuy: toBuy,
    newVersion: newVersion,
    mandatory: mandatory,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
