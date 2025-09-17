import 'base_dao_model.dart';

class PaginationDaoModel extends BaseDaoModel {
  static const limitKey = "limit";
  static const offsetKey = "offset";
  static const defaultLimit = 10;
  static const defaultOffset = 0;
  int limit;
  int offset;

  PaginationDaoModel({this.limit = defaultLimit, this.offset = defaultOffset})
    : assert(limit > 0, "$limitKey must be greater than 0"),
      assert(offset > 0, "$offsetKey must be greater than 0");
}
