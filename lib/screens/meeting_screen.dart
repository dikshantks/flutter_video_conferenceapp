import 'package:flutter/material.dart';
import 'package:flutter_zoom_clone/services/meet_kit.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key, required this.name});
  final String name;
  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  bool isLocalAudioOn = true;
  bool isLocalVideoOn = true;
  Offset position = const Offset(10, 10);

  Future<bool> leaveRoom() async {
    final meetkit = context.read<MeetingKit>();
    await meetkit.actions.leaveroom(meetkit);
    Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    final meetingkit = context.read<MeetingKit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meetingkit = context.watch<MeetingKit>();

    HMSPeer localpeer;

    for (HMSPeer each in meetingkit.allPeers) {
      if (each.isLocal) {
        localpeer = each;
      }
    }
    return WillPopScope(
      onWillPop: () async {
        return leaveRoom();
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              MeetUI(),
              Align(
                // 3 buttons
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          leaveRoom();
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Colors.red.withAlpha(60),
                              blurRadius: 3.0,
                              spreadRadius: 5.0,
                            ),
                          ]),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.call_end, color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {
                          meetingkit.actions.sdk
                              .switchVideo(isOn: isLocalVideoOn),
                          if (!isLocalVideoOn)
                            {meetingkit.actions.sdk.startCapturing()}
                          else
                            {meetingkit.actions.sdk.stopCapturing()},
                          setState(() {
                            isLocalVideoOn = !isLocalVideoOn;
                          }),
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent.withOpacity(0.2),
                          child: Icon(
                            isLocalVideoOn
                                ? Icons.videocam
                                : Icons.videocam_off_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {
                          meetingkit.actions.sdk
                              .switchAudio(isOn: isLocalAudioOn),
                          setState(() {
                            isLocalAudioOn = !isLocalAudioOn;
                          })
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent.withOpacity(0.2),
                          child: Icon(
                            isLocalAudioOn ? Icons.mic : Icons.mic_off,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                // switch camera
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    if (isLocalVideoOn) {
                      meetingkit.actions.sdk.switchCamera();
                    }
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent.withOpacity(0.2),
                    child: const Icon(
                      Icons.switch_camera_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeetUI extends StatelessWidget {
  const MeetUI({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final meetingkit = context.watch<MeetingKit>();

    List<HMSPeer> current = meetingkit.allPeers;
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10),
      height: size.height,
      width: size.width,
      // color: Colors.green,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0),
        itemCount: meetingkit.allPeers.length,
        itemBuilder: ((context, index) => MeetPeerTile(
              peer: current[index],
            )),
      ),
    );
  }
}
