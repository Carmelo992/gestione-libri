import '../../core/core.dart';
import '../dao/update_books_classes_dao_model.dart';
import 'books_classes_model.dart';

class UpdateBooksClassesModel extends BaseAdapterModel<UpdateBooksClassesDaoModel> {
  static const nameKey = BooksClassesModel.nameKey;
  static const String classIdKey = BooksClassesModel.classIdKey;
  static const String bookIdKey = BooksClassesModel.bookIdKey;

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String? name;
  final int? classId;
  final int? bookId;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  UpdateBooksClassesModel(Map<String, dynamic> data, [String? booksClassesId])
    : name = data[nameKey],
      classId = data[classIdKey],
      bookId = data[bookIdKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => BooksClassesModel.fieldTypes;

  static String? validateField(dynamic value, String key) => BooksClassesModel.validateField(value, key);

  @override
  UpdateBooksClassesDaoModel toDao() => UpdateBooksClassesDaoModel(
    name: name,
    classId: classId,
    bookId: bookId,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
