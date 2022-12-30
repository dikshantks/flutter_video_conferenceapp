import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_zoom_clone/services/meet_kit.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import 'package:http/http.dart' as https;

class JoinService {
  late HMSSDK sdk;
  late HMSConfig hmsConfig;

  JoinService() {
    sdk = HMSSDK();
  }
  Future<void> join(
    String name,
    String id,
  ) async {
    String idk = "demodk";
    String roomID = "63a2aee7aac408cad8c050b2";
    Uri endpoint = Uri.parse(
        "https://prod-in2.100ms.live/hmsapi/$idk.app.100ms.live/api/token");

    https.Response response = await https
        .post(endpoint, body: {'user_id': name, 'room_id': id, 'role': "host"});

    var body = json.decode(response.body);

    final String tokens = body["token"];
    HMSConfig config = HMSConfig(authToken: tokens, userName: name);
    await sdk.join(config: config);
  }

  Future<void> leaveroom(MeetingKit meetingKit) async {
    sdk.removeUpdateListener(listener: meetingKit);
    await sdk.leave();
    meetingKit.clear();
  }
}
