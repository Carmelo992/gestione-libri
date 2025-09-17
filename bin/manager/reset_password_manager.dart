import 'dart:async';
import 'dart:math';

import './mail_manager.dart';

class ResetPasswordManager {
  static final List<_PasswordResetRequest> _requests = [];

  static Future<String?> code(int userId, String email, String fullName) async {
    var request = _PasswordResetRequest(userId);

    try {
      var mailSent = await MailManager.sendResetCodeMail(email, fullName, request.code);
      if (!mailSent) return null;
      _requests.removeWhere((req) => req.userId == userId);
      _requests.add(request);
      return request.code;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static bool validate(int userId, String code) {
    var request =
        _requests
            .where((req) => req.userId == userId && code == req.code && req.expirationDate.isAfter(DateTime.now()))
            .firstOrNull;
    return request != null;
  }

  static void startCleanJob() {
    Timer.periodic(Duration(hours: 12), (_) {
      _requests.removeWhere((req) => req.expirationDate.isBefore(DateTime.now()));
    });
  }
}

class _PasswordResetRequest {
  int userId;
  DateTime requestDate;
  DateTime expirationDate;
  String code;

  _PasswordResetRequest(this.userId)
    : requestDate = DateTime.now(),
      expirationDate = DateTime.now().add(Duration(minutes: 30)),
      code = Random().nextInt(1000000).toString().padLeft(6, "0");
}
