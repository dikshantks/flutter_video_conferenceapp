import 'package:flutter/material.dart';
import 'package:flutter_zoom_clone/services/join_service.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class MeetingKit extends ChangeNotifier implements HMSUpdateListener {
  late JoinService actions;

  List<HMSPeer> allPeers = [];

  Future<void> init() async {
    actions = JoinService();

    await actions.sdk.build();

    actions.sdk.addUpdateListener(listener: this);
  }

  void clear() {
    allPeers.clear();
  }

  Future<void> leaveroom() async {}

  ///////////////////////////////////////////////////////////////////////////////

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // TODO: implement onAudioDeviceChanged
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onHMSError({required HMSException error}) {
    // TODO: implement onHMSError
  }

  @override
  void onJoin({required HMSRoom room}) {
    //done
    if (room.peers != null) {
      allPeers = room.peers!;
    }
    notifyListeners();
  }

  @override
  void onMessage({required HMSMessage message}) {
    // TODO: implement onMessage
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    //done
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        allPeers.add(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        allPeers.remove(peer);
        break;
      case HMSPeerUpdate.roleUpdated:
      case HMSPeerUpdate.metadataChanged:
      case HMSPeerUpdate.nameChanged:
      case HMSPeerUpdate.defaultUpdate:
      case HMSPeerUpdate.networkQualityUpdated:
        break;
    }
    notifyListeners();
  }

  @override
  void onReconnected() {
    // TODO: implement onReconnected
  }

  @override
  void onReconnecting() {
    // TODO: implement onReconnecting
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // TODO: implement onRemovedFromRoom
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
//done
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }
}
