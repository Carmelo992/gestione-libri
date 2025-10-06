import '../../core/core.dart';
import '../dao/update_website_dao_model.dart';
import 'website_model.dart';

class UpdateWebsiteModel extends BaseAdapterModel<UpdateWebsiteDaoModel> {
  static const nameKey = WebsiteModel.nameKey;

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String? name;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  UpdateWebsiteModel(Map<String, dynamic> data, [String? websiteId]) : name = data[nameKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => WebsiteModel.fieldTypes;

  static String? validateField(dynamic value, String key) => WebsiteModel.validateField(value, key);

  @override
  UpdateWebsiteDaoModel toDao() => UpdateWebsiteDaoModel(
    name: name,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
