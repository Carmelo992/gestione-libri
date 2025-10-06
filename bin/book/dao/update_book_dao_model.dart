import '../../core/core.dart';
import 'book_dao_model.dart';

class UpdateBookDaoModel extends BaseDaoModel {
  static const nameKey = BookDaoModel.nameKey;
  static const String bookCodeKey = BookDaoModel.bookCodeKey;
  static const String priceKey = BookDaoModel.priceKey;

  String? name, bookCode;
  double? price;

  UpdateBookDaoModel({required this.name, required this.bookCode, required this.price});
}
