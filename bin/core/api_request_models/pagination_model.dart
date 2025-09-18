import '../dao/pagination_dao_model.dart';
import '../strings.dart';
import 'base_adapter_model.dart';

class PaginationModel extends BaseAdapterModel<PaginationDaoModel> {
  static const limitKey = "limit";
  static const offsetKey = "offset";
  static const defaultLimit = 10;
  static const defaultOffset = 0;
  int limit;
  int offset;

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => {};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      limitKey => (int.tryParse(value as String) ?? -1) <= 0 ? StringsManager.mustBeGreaterThanZero() : null,
      offsetKey => (int.tryParse(value as String) ?? -1) < 0 ? StringsManager.mustBePositiveNumber() : null,
      _ => null,
    };
  }

  PaginationModel(Map<String, dynamic> data)
    : limit = int.tryParse(data[limitKey] ?? defaultLimit.toString()) ?? defaultLimit,
      offset = int.tryParse(data[offsetKey] ?? defaultOffset.toString()) ?? defaultOffset;

  @override
  PaginationDaoModel toDao() => PaginationDaoModel(limit: limit, offset: offset);
}
