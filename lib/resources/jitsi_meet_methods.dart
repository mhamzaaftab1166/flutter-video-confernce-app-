import 'package:flutter/cupertino.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import '../utils/features_flag.dart';
import 'firestore_methods.dart';
import 'auth_methods.dart';
import'dart:core';

class JitsiMeetMethod {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  final TextEditingController serverText = TextEditingController();
  final TextEditingController roomText = TextEditingController(text: "jitsi-meet-wrapper-test-room");
  final TextEditingController subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final TextEditingController tokenText = TextEditingController();

  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      String? serverUrl =
          serverText.text.trim().isEmpty ? null : serverText.text;

      var FeatureFlagVideoResolution;
      Map<FeatureFlag, dynamic> featureFlags = {
       FeatureFlag.isWelcomePageEnabled: false,
         FeatureFlag.resolution: FeatureFlagVideoResolution.MD_RESOLUTION,
      };

      String name = username.isEmpty ? _authMethods.user?.displayName ?? '' : username;
      String? userEmail = _authMethods.user?.email;

    
      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomText.text,
        serverUrl: serverUrl,
        subject: subjectText.text,
        token: tokenText.text,
        isAudioMuted: isAudioMuted,
        isAudioOnly: isAudioOnly,
        isVideoMuted: isVideoMuted,
        userDisplayName: name,
        userEmail: userEmail,
      // featureFlags: featureFlags2,
      );

      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          // Your listener callbacks here
        ),
      );

      _firestoreMethods.addToMeetingHistory(roomName);
    } catch (error) {
      print("error: $error");
    }
  }
}
