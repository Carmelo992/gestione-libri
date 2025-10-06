import '../../core/core.dart';
import 'transaction_dao_model.dart';

class UpdateTransactionDaoModel extends BaseDaoModel {
  static const String studentIdKey = TransactionDaoModel.studentIdKey;
  static const String amountKey = TransactionDaoModel.amountKey;
  static const String typeKey = TransactionDaoModel.typeKey;

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final int? studentId;
  final int? amount;
  final int? transactionType;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  UpdateTransactionDaoModel({
    required this.studentId,
    required this.amount,
    required this.transactionType,
    //CONSTRUCTOR_PLACE_HOLDER
    //Do not remove the line above
  });
}
