import '../../core/core.dart';
import '../dao/update_transaction_dao_model.dart';
import 'transaction_model.dart';

class UpdateTransactionModel extends BaseAdapterModel<UpdateTransactionDaoModel> {
  static const String studentIdKey = TransactionModel.studentIdKey;
  static const String amountKey = TransactionModel.amountKey;
  static const String typeKey = TransactionModel.typeKey;

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final int? studentId;
  final double? amount;
  final int? transactionType;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  UpdateTransactionModel(Map<String, dynamic> data, [String? transactionId])
    : studentId = data[studentIdKey],
      amount = data[amountKey],
      transactionType = data[typeKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => TransactionModel.fieldTypes;

  static String? validateField(dynamic value, String key) => TransactionModel.validateField(value, key);

  @override
  UpdateTransactionDaoModel toDao() => UpdateTransactionDaoModel(
    studentId: studentId,
    amount: amount == null ? null : (amount! * 100).ceil(),
    transactionType: transactionType,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
