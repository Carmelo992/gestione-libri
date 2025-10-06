import '../../core/core.dart';

class TransactionDaoModel extends BaseDaoModel {
  static const String studentIdKey = "student_id";
  static const String amountKey = "amount";
  static const String typeKey = "transaction_type";

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final int studentId;
  final int amount;
  final int transactionType;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  TransactionDaoModel({
    required this.studentId,
    required this.amount,
    required this.transactionType,
    //CONSTRUCTOR_PLACE_HOLDER
    //Do not remove the line above
  });
}
