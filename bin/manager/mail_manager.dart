import 'dart:convert';

import 'package:http/http.dart';

import '../core/core.dart';

class MailManager {
  static const String API_KEY = String.fromEnvironment("MAILJET_API_KEY");
  static const String SECRET_KEY = String.fromEnvironment("MAILJET_SECRET_KEY");

  static Future<bool> _sendMail(
    String email,
    String fullName,
    String message,
    String htmlMessage,
    String subject,
  ) async {
    try {
      var result = await post(
        Uri.parse("https://api.mailjet.com/v3.1/send"),
        headers: {"Authorization": "Basic ${utf8.fuse(base64).encode("$API_KEY:$SECRET_KEY")}"},
        body: jsonEncode({
          "Messages": [
            {
              "From": {"Email": "carmelo@beeapp.it", "Name": "Emile-NoReply"},
              "To": [
                {"Email": email, "Name": fullName},
              ],
              "Subject": subject,
              "TextPart": message,
              "HTMLPart": htmlMessage,
            },
          ],
        }),
      );
      var success = result.statusCode == 200;
      if (!success) {
        Logger.error(result.body);
      }
      return success;
    } catch (e) {
      Logger.error(e.toString());
      return false;
    }
  }

  static Future<bool> sendResetCodeMail(String email, String fullName, String code) async {
    return _sendMail(
      email,
      fullName,
      "${StringsManager.resetPasswordTitle()}\n${StringsManager.resetPasswordMessage()}\n$code",
      _resetEmailHtml(code),
      StringsManager.resetPasswordTitle(),
    );
  }

  static String _resetEmailHtml(String code) =>
      _templateHtml(StringsManager.resetPasswordTitle(), StringsManager.resetPasswordMessage(), [code]);

  static String _newResourceEmailHtml(String email, password) =>
      _templateHtml(StringsManager.newResourceTitle(), StringsManager.newResourceMessage(), [email, password]);

  static Future<bool> sendNewUserEmail(String fullName, String email, String password) async {
    return _sendMail(
      email,
      fullName,
      "${StringsManager.newResourceTitle()}\n${StringsManager.newResourceMessage()}\n$email\n$password",
      _newResourceEmailHtml(email, password),
      StringsManager.newResourceTitle(),
    );
  }

  static String _templateHtml(String title, String message, List<String> codes) =>
      """
  <!doctype html>
  <html lang="it-IT">
    <head>
      <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
      <title>$title</title>
      <style type="text/css">
        a:hover {
          text-decoration: underline !important;
        }
      </style>
    </head>
    
    <body marginheight="0" topmargin="0" marginwidth="0" style="margin: 0px; background-color: #f2f3f8;" leftmargin="0">
      <!--100% body table-->
      <table cellspacing="0" border="0" cellpadding="0" width="100%" bgcolor="#f2f3f8" style="@import url(https://fonts.googleapis.com/css?family=Rubik:300,400,500,700|Open+Sans:300,400,600,700); font-family: 'Open Sans', sans-serif;">
        <tr>
          <td>
            <table style="background-color: #f2f3f8; max-width:670px;  margin:0 auto;" width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td style="height:80px;">&nbsp;</td>
              </tr>
    
              <tr>
                <td style="height:20px;">&nbsp;</td>
              </tr>
              <tr>
                <td>
                  <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" style="max-width:670px;background:#fff; border-radius:3px; text-align:center;-webkit-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);-moz-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);box-shadow:0 6px 18px 0 rgba(0,0,0,.06);">
                    <tr>
                      <td style="height:40px;">&nbsp;</td>
                    </tr>
                    <tr>
                      <td style="padding:0 35px;">
                        <h1 style="color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;">$title</h1>
                        <span style="display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;"></span>
                        <p style="color:#455056; font-size:15px;line-height:24px; margin:0;">
                          $message
                        </p>
                        <span style="display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;"></span>
                        ${codes.map((code) => '''<h1 style="color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;">$code</h1>''').join("</br>")}
                      </td>
                    </tr>
                    <tr>
                      <td style="height:40px;">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              <tr>
                <td style="height:20px;">&nbsp;</td>
              </tr>
    
              <tr>
                <td style="height:80px;">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <!--/100% body table-->
    </body>
  </html>
""";
}
