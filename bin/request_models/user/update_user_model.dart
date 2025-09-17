import '../../dao/user/update_user_dao_model.dart';
import '../base_adapter_model.dart';
import './user_model.dart';

class UpdateResourceModel extends BaseAdapterModel<UpdateUserDaoModel> {
  static const firstNameKey = UserModel.firstNameKey;
  static const lastNameKey = UserModel.lastNameKey;

  String? firstName;
  String? lastName;

  UpdateResourceModel(Map<String, dynamic> data, [String? clientId])
    : firstName = data[firstNameKey],
      lastName = data[lastNameKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => UserModel.fieldTypes;

  static String? validateField(dynamic value, String key) => UserModel.validateField(value, key);

  @override
  UpdateUserDaoModel toDao() => UpdateUserDaoModel(firstName: firstName, lastName: lastName);
}
