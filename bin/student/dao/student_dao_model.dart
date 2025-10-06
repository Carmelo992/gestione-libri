import '../../core/core.dart';

class StudentDaoModel extends BaseDaoModel {
  static const nameKey = "name";
  static const surnameKey = "surname";
  static const phoneNumberKey = "phone_number";

  String name, surname, phoneNumber;

  StudentDaoModel({required this.name, required this.surname, required this.phoneNumber});
}
