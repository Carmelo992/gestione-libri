import '../../core/core.dart';
import '../dao/website_dao_model.dart';

class WebsiteModel extends BaseAdapterModel<WebsiteDaoModel> {
  static const nameKey = "name";

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String name;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  WebsiteModel(Map<String, dynamic> data, [String? websiteId]) : name = data[nameKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [
    nameKey,
    //REQUIRED_FIELD_PLACE_HOLDER
    //Do not remove the line above
  ];

  static Map<String, Type> get fieldTypes => {
    nameKey: String,
    //FIELD_TYPE_PLACE_HOLDER
    //Do not remove the line above
  };

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      //TODO add custom validation rule here
      _ => null,
    };
  }

  @override
  WebsiteDaoModel toDao() => WebsiteDaoModel(
    name: name,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
