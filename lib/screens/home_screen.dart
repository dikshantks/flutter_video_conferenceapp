// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_zoom_clone/models/data_store.dart';
import 'package:flutter_zoom_clone/screens/meeting_screen.dart';
import 'package:flutter_zoom_clone/services/join_service.dart';
import 'package:flutter_zoom_clone/services/sdk_initializer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
  }

  @override
  void initState() {
    getPermissions();
    SdkInit.hmssdk.build();
    super.initState();
  }

  bool _isloading = false;
  late UserData _datastore;

  Future<bool> joinRoom() async {
    setState(() {
      _isloading = true;
    });
    bool isJoinSuccessfull = await JoinService.join(SdkInit.hmssdk);
    if (!isJoinSuccessfull) {
      return false;
    }
    _datastore = UserData();
    _datastore.startListen();
    setState(() {
      _isloading = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: const Text("Meet"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Google Meet',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ],
          ), // Populate the Drawer in the next step.
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 200,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              ListTile(
                                title: Row(
                                  children: const [
                                    Icon(Icons.video_call),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Start an instant meeting'),
                                  ],
                                ),
                                onTap: () async {
                                  bool isJoined = await joinRoom();
                                  if (isJoined) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ListenableProvider.value(
                                          value: _datastore,
                                          child: const MeetingScreen(),
                                        ),
                                      ),
                                    );
                                  } else {
                                    const SnackBar(content: Text("Error"));
                                  }
                                },
                              ),
                              ListTile(
                                title: Row(
                                  children: const [
                                    Icon(Icons.close),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Close'),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('New meeting'),
                ),
                OutlinedButton(
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.white)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white)),
                  onPressed: () {},
                  child: const Text('Join with a code'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
