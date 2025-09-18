import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  const port = String.fromEnvironment("PORT", defaultValue: '8182');
  final host = 'http://0.0.0.0:$port';
  final webHost = '$host/web';

  List<int> arcadiaIds = [];

  // Admin Login
  final adminLogin = await post(
    Uri.parse('$host/auth/login'),
    headers: {"X-APP-WEB": "true"},
    body: jsonEncode({"email": "admin@admin.it", "password": "B33@ppSrl!"}),
  );
  Map<String, dynamic> responseBody = jsonDecode(adminLogin.body);
  var adminToken = responseBody["token"];
  var adminHeader = {"Authorization": "Bearer $adminToken"};

  await put(Uri.parse('$webHost/city'), body: jsonEncode({"name": "Pisa"}), headers: adminHeader);
  await put(Uri.parse('$webHost/city'), body: jsonEncode({"name": "Scicli"}), headers: adminHeader);
  await put(Uri.parse('$webHost/city'), body: jsonEncode({"name": "Navacchio"}), headers: adminHeader);
  await put(Uri.parse('$webHost/city'), body: jsonEncode({"name": "Ragusa"}), headers: adminHeader);
  await put(Uri.parse('$webHost/city'), body: jsonEncode({"name": "Modica"}), headers: adminHeader);
}
