import '../../core/core.dart';
import '../dao/update_order_dao_model.dart';
import 'order_model.dart';

class UpdateOrderModel extends BaseAdapterModel<UpdateOrderDaoModel> {
  static const nameKey = OrderModel.nameKey;

  String? name;

  UpdateOrderModel(Map<String, dynamic> data, [String? orderId]) : name = data[nameKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => OrderModel.fieldTypes;

  static String? validateField(dynamic value, String key) => OrderModel.validateField(value, key);

  @override
  UpdateOrderDaoModel toDao() => UpdateOrderDaoModel(name);
}
