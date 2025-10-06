import '../../core/core.dart';
import '../dao/update_book_dao_model.dart';
import 'book_model.dart';

class UpdateBookModel extends BaseAdapterModel<UpdateBookDaoModel> {
  static const nameKey = BookModel.nameKey;
  static const String bookCodeKey = BookModel.bookCodeKey;
  static const String priceKey = BookModel.priceKey;

  String? name, bookCode;
  double? price;

  UpdateBookModel(Map<String, dynamic> data, [String? bookId]) : name = data[nameKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => BookModel.fieldTypes;

  static String? validateField(dynamic value, String key) => BookModel.validateField(value, key);

  @override
  UpdateBookDaoModel toDao() => UpdateBookDaoModel(name: name, bookCode: bookCode, price: price);
}
