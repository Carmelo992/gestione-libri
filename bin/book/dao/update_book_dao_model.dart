import '../../core/core.dart';
import 'book_dao_model.dart';

class UpdateBookDaoModel extends BaseDaoModel {
  static const nameKey = BookDaoModel.nameKey;

  String? name;

  UpdateBookDaoModel(this.name);
}
