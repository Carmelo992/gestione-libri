import '../../core/core.dart';

class BookDaoModel extends BaseDaoModel {
  static const nameKey = "name";
  static const String bookCodeKey = "book_code";
  static const String priceKey = "price";

  String name, bookCode;
  double price;

  BookDaoModel({required this.name, required this.bookCode, required this.price});
}
