import '../../core/core.dart';
import '../dao/book_dao_model.dart';

class BookModel extends BaseAdapterModel<BookDaoModel> {
  static const nameKey = "name";

  String name;

  BookModel(Map<String, dynamic> data, [String? bookId]) : name = data[nameKey];

  static List<String> get requiredFields => [nameKey];

  static Map<String, Type> get fieldTypes => {nameKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }

  @override
  BookDaoModel toDao() => BookDaoModel(name);
}
