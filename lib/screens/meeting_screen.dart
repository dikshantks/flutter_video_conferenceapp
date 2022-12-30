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
  bool _isLoading = false;
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
                          // SdkInit.hmssdk.switchVideo(isOn: widget.isLocalVideoOn),
                          // if (!widget.isLocalVideoOn)
                          //   SdkInit.hmssdk.startCapturing()
                          // else
                          //   SdkInit.hmssdk.stopCapturing(),
                          // setState(() {
                          //   widget.isLocalVideoOn = !widget.isLocalVideoOn;
                          // })
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent.withOpacity(0.2),
                          child: Icon(
                            // widget.isLocalVideoOn
                            true ? Icons.videocam : Icons.videocam_off_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {
                          // SdkInit.hmssdk.switchAudio(isOn: widget.isLocalAudioOn),
                          // setState(() {
                          //   widget.isLocalAudioOn = !widget.isLocalAudioOn;
                          // })
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent.withOpacity(0.2),
                          child: Icon(
                            // widget.isLocalAudioOn
                            true ? Icons.mic : Icons.mic_off,
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
                    // if (widget.isLocalVideoOn) {

                    // }
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
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 20.0),
        itemCount: meetingkit.allPeers.length,
        itemBuilder: ((context, index) => MeetPeerTile(
              peer: current[index],
            )),
      ),
    );
  }
}
