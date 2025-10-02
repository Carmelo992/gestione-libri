import '../../core/core.dart';
import '../dao/order_dao_model.dart';

class OrderModel extends BaseAdapterModel<OrderDaoModel> {
  static const nameKey = "name";

  String name;

  OrderModel(Map<String, dynamic> data, [String? orderId]) : name = data[nameKey];

  static List<String> get requiredFields => [nameKey];

  static Map<String, Type> get fieldTypes => {nameKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }

  @override
  OrderDaoModel toDao() => OrderDaoModel(name);
}
