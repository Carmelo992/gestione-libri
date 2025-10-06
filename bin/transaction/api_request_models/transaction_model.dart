import '../../core/core.dart';
import '../dao/transaction_dao_model.dart';

class TransactionModel extends BaseAdapterModel<TransactionDaoModel> {
  static const String studentIdKey = "studentId";
  static const String amountKey = "amount";
  static const String typeKey = "transactionType";

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final int studentId;
  final double amount;
  final int transactionType;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  TransactionModel(Map<String, dynamic> data, [String? transactionId])
    : studentId = data[studentIdKey],
      amount = data[amountKey],
      transactionType = data[typeKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [
    studentIdKey,
    amountKey,
    typeKey,
    //REQUIRED_FIELD_PLACE_HOLDER
    //Do not remove the line above
  ];

  static Map<String, Type> get fieldTypes => {
    studentIdKey: int,
    amountKey: double,
    typeKey: int,
    //FIELD_TYPE_PLACE_HOLDER
    //Do not remove the line above
  };

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      typeKey => [0, 1].contains(value as int) ? null : StringsManager.invalidTransactionType(),
      //TODO add custom validation rule here
      _ => null,
    };
  }

  @override
  TransactionDaoModel toDao() => TransactionDaoModel(
    studentId: studentId,
    amount: (amount * 100).ceil(),
    transactionType: transactionType,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
