import "../dao/base_dao_model.dart";

abstract class BaseAdapterModel<T extends BaseDaoModel> {
  T toDao();
}
