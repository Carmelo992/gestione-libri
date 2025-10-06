import '../../core/core.dart';
import '../dao/book_dao_model.dart';

class BookModel extends BaseAdapterModel<BookDaoModel> {
  static const nameKey = "name";
  static const String bookCodeKey = "bookCode";
  static const String priceKey = "price";

  String name, bookCode;
  double price;

  BookModel(Map<String, dynamic> data, [String? bookId])
    : name = data[nameKey],
      bookCode = data[bookCodeKey],
      price = data[priceKey];

  static List<String> get requiredFields => [nameKey, bookCodeKey, priceKey];

  static Map<String, Type> get fieldTypes => {nameKey: String, bookCodeKey: String, priceKey: double};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      bookCodeKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      priceKey => (value as double) <= 0 ? StringsManager.invalidPrice() : null,

      _ => null,
    };
  }

  @override
  BookDaoModel toDao() => BookDaoModel(name: name, bookCode: bookCode, price: price);
}
