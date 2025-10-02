import '../../core/core.dart';
import 'order_dao_model.dart';

class UpdateOrderDaoModel extends BaseDaoModel {
  static const nameKey = OrderDaoModel.nameKey;

  String? name;

  UpdateOrderDaoModel(this.name);
}
