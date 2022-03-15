import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CallNotifier extends ChangeNotifier {
  var _users = <int>[];
  var _infoStrings = <String>[];
  bool _isMuted = false;
  late RtcEngine _engine;

  RtcEngine get engine => _engine;

  set setEngine(RtcEngine engine) {
    _engine = engine;
    notifyListeners();
  }

  bool get isMuted => _isMuted;

  set isMuted(value) {
    _isMuted = !value;
    notifyListeners();
  }

  get users => _users;

  addUser(value) {
    _users.add(value);
    notifyListeners();
  }

  get infoStrings => _infoStrings;

  infoString(String value) {
    _infoStrings.add(value);
    notifyListeners();
  }

  removeUser(value) {
    _users.remove(value);
    notifyListeners();
  }

  clearUsers() {
    _users.clear();
    notifyListeners();
  }

  Future<void> init(String channelName, context) async {
    if (Agora.APP_ID.isEmpty) {
      infoString('APP_ID missing, please provide your APP_ID in settings.dart');
      infoString('Agora Engine is not starting');
      return;
    }
    await _initAgoraRtcEngine().whenComplete(() async {
      _addAgoraEventHandlers(context);
      await _engine.enableLocalVideo(true);
      VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
      configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
      await _engine.setVideoEncoderConfiguration(configuration);
      await _engine.joinChannel(Agora.Token, channelName, null, 0);
    });
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(Agora.APP_ID);
    setEngine = _engine;
    notifyListeners();
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  Future<void> endCall(context) async {
    await _engine.leaveChannel();
    await _engine.destroy();
  }

  void _addAgoraEventHandlers(context) {
    _engine.setEventHandler(RtcEngineEventHandler(
        error: (code) {
          infoString('onError: $code');
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          // infoString('onJoinChannel: $channel, uid: $uid');
        },
        leaveChannel: (stats) {
          infoString('onLeaveChannel');
          _users.clear();
        },
        userJoined: (uid, elapsed) async {
          infoString('${CommonConstants.calljoinername} joined');
          addUser(uid);
          CommonConstants.isCallConnected = true;
          ///write logic for emit this event from call joiner side
          if (CommonConstants.receiverId == CommonConstants.userID) {
            CommonConstants.socket.emit('call-connected', {
              "c_charge": CommonConstants.userCallCharge,
              "room": CommonConstants.receiverId,
              "userId": CommonConstants.callerId,
              "callLogId": CommonConstants.callerCallLogId,
              "memberCallLogId": CommonConstants.memberCallLogId,
            });
          } else {
            print("Receiver Id Doesn't matched================--------------");
          }
          // print("caller 1 :- ${CommonConstants.caller}");
          // print("Socket connection:::::- ${CommonConstants.socket.connected}");
          // CommonConstants.socket
          //     .emit('call-accept', {"id": CommonConstants.socketID, "uid": 1});
          // CommonConstants.socket.emit('call-connected', {
          //   "id": CommonConstants.socketID,
          //   "c_charge": 50,
          //   "u_mobile": "9601603611",
          //   "room": "1"
          // });
          // CommonConstants.socket.once("balance_ok", (data) {
          //   print("========== on balance_ok ==== call model");
          //   Fluttertoast.showToast(msg: "balance_ok :- $data");
          //   if (data == "1") {
          //     if (CommonConstants.socket.connected) {
          //       CommonConstants.socket.emit('call-connected', {
          //         "id": CommonConstants.socketID,
          //         "c_charge": 50,
          //         "u_mobile": "9601603611",
          //         "room": 1
          //       });
          //       CommonConstants.caller = false;
          //       notifyListeners();
          //       print("caller 3 :- ${CommonConstants.caller}");
          //     } else {
          //       Fluttertoast.showToast(
          //           msg:
          //               "On User Join Socket Connection is :- ${CommonConstants.socket.connected}");
          //     }
          //   } else {
          //     print("balance_ok uid not matched :------$data");
          //   }
          // });
          // CommonConstants.socket.emit('join_room', {
          //   {"room": 1}
          // });

          /// comment below code for join video call
          // if (CommonConstants.caller) {
          //   print("caller 2 :- ${CommonConstants.caller}");
          //
          //   if (CommonConstants.socket.connected) {
          //     CommonConstants.socket.emit('call-connected', {
          //       "id": CommonConstants.socketID,
          //       "c_charge": 50,
          //       "u_mobile": "9601603611",
          //       "room": 1
          //     });
          //     CommonConstants.caller = false;
          //     notifyListeners();
          //     print("caller 3 :- ${CommonConstants.caller}");
          //   } else {
          //     Fluttertoast.showToast(
          //         msg:
          //             "On User Join Socket Connection is :- ${CommonConstants.socket.connected}");
          //   }
          // } else {}

          // CommonConstants.socket.once("call_disconnected_manually", (data) async {
          //   print("========== on call_disconnected_manually ====");
          //   CommonConstants.CallDone = "";
          //   endCall(context);
          //   notifyListeners();
          //   Navigator.pop(context);
          // });
          // CommonConstants.socket.once("balance_not_ok", (data) async {
          //   print("========== on balance_not_ok ==== call model");
          //   CommonConstants.CallDone = "";
          //   notifyListeners();
          //   endCall(context);
          //   Fluttertoast.showToast(msg: "balance_not_ok :- $data");
          //   Navigator.pop(context);
          //   // CommonConstants.socket.emit('call-disconnected',
          //   //     {"isManual": false, "id": CommonConstants.socketID, "room": 1});
          //
          //   // if(data==true) {
          //   // print("balance_not_ok - data = $data");
          //   // Fluttertoast.showToast(msg: "balance_not_ok - data = $data");
          //   // CommonConstants.socket.emit('call-disconnected',
          //   //     {"isManual": false, "id": CommonConstants.socketID, "room": 1});
          //   // }
          //   // else{
          //   //
          //   // }
          // });
        },
        userOffline: (uid, elapsed) {
          infoString('userOffline: $uid');
          removeUser(uid);
          // endCall(context);
          // CommonConstants.socket.emit('call-disconnected', false);
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {}));
  }

  @override
  void dispose() {
    clearUsers();
    _engine.destroy();
    _engine.leaveChannel();
    super.dispose();
  }
}
