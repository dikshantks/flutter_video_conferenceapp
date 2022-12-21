import 'dart:convert';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import 'package:http/http.dart' as https;

class JoinService {
  static Future<bool> join(HMSSDK hmssdk) async {
    String roomID = "63a2aee7aac408cad8c050b2";
    Uri endpoint = Uri.parse(
        "https://prod-in2.100ms.live/hmsapi/demodk.app.100ms.live/api/token");

    https.Response response = await https.post(endpoint,
        body: {'user_id': "user", 'room_id': roomID, 'role': "host"});

    var body = json.decode(response.body);
    if (body == null || body['token'] == null) {
      return false;
    }
    HMSConfig config = HMSConfig(authToken: body["token"], userName: "user");
    await hmssdk.join(config: config);

    return true;
  }
}
