import 'dart:convert';
import 'dart:math';

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

  var clientResponse = await put(
    Uri.parse('$webHost/clients'),
    body: jsonEncode({"name": "Beeapp", "city": "Navacchio"}),
    headers: adminHeader,
  );
  var response = jsonDecode(clientResponse.body);
  // Add devices
  var random = Random();
  for (int i = 0; i < 10; i++) {
    var addDevice = await put(
      Uri.parse('$webHost/devices'),
      body: jsonEncode({
        "address": [
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        ].map((e) => e.toRadixString(16).padLeft(2, "0").toUpperCase()).join(":"),
        "name": "ARCADIA-${(i + 1).toString().padLeft(3, "0")}",
        "clientId": response["id"],
      }),
      headers: adminHeader,
    );
    responseBody = jsonDecode(addDevice.body);
    print(responseBody);
    arcadiaIds.add(responseBody["id"]);
  }
}
