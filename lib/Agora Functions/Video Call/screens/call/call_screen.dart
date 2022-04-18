// ignore_for_file: library_prefixes

import 'dart:convert';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:astro/Agora%20Functions/Video%20Call/screens/base_widget.dart';
import 'package:astro/Agora%20Functions/Video%20Call/screens/call/call_model.dart';
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CallScreen extends StatefulWidget {
  final String? channelName;

  const CallScreen({Key? key, this.channelName}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}
// final GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();

class _CallScreenState extends State<CallScreen> {
  bool manually1 = false;
  bool manually2 = false;
  bool callRejected = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Helper function to get list of native views
  List<Widget> _getRenderViews(CallNotifier model) {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    model.users
        .forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(
        child: Container(
      child: view,
    ));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Row(
      children: wrappedViews,
    );
  }

  /// Video layout wrapper
  Widget _viewRows(CallNotifier notifier) {
    final views = _getRenderViews(notifier);
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
      case 2:
        return Stack(
          children: <Widget>[
            _expandedVideoRow([views[1]]),
            Positioned(
              bottom: 120,
              right: 20,
              child: SizedBox(
                  height: 180,
                  width: 100,
                  child: _expandedVideoRow([views[0]])),
            )
          ],
        );
      case 3:
        return Expanded(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Expanded(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar(CallNotifier notifier) {
    //if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onToggleMute(notifier),
            child: Icon(
              notifier.isMuted ? Icons.mic_off : Icons.mic,
              color: notifier.isMuted ? Colors.white : Colors.teal,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: notifier.isMuted ? Colors.teal : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(notifier),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => _onSwitchCamera(notifier),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.teal,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel(CallNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 55),
          child: ListView.builder(
            reverse: true,
            itemCount: notifier.infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (notifier.infoStrings.isEmpty) {
                return const CircularProgressIndicator(
                  color: Colors.red,
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color:CommonConstants.appcolor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          notifier.infoStrings[index],
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onCallEnd(notifier) async {
    if (CommonConstants.isCallConnected) {
      CommonConstants.socket.emit('call-disconnected', {
        "id": CommonConstants.socketID,
        "room": CommonConstants.room,
        "userId": CommonConstants.callerIdforStatusChange,
        "isCallNotConnected": false,
      });
      setState(() {
        CommonConstants.isCallConnected = false;
      });
      print('userID:::::::::: :- ${CommonConstants.callerIdforStatusChange}');

    } else {
      CommonConstants.socket.emit('call-disconnected', {
        "id": CommonConstants.socketID,
        "room": CommonConstants.room,
        "isCallNotConnected": true,
      });
      await notifier.endCall(context);
      Fluttertoast.showToast(msg: "Call Ended");
      Get.back();
    }
  }

  Future<void> _onCallRejected(notifier) async {
    callRejected = true;
    await notifier.endCall(context);
    Get.back();
    CommonConstants.socket.emit('leave_room', CommonConstants.room);
    Fluttertoast.showToast(
        msg: "Call rejected by ${CommonConstants.calljoinername}");
  }

  void _onToggleMute(CallNotifier notifier) {
    notifier.isMuted = notifier.isMuted;
    notifier.engine.muteLocalAudioStream(notifier.isMuted);
  }

  void _onSwitchCamera(CallNotifier model) {
    model.engine.switchCamera();
  }

  @override
  void initState() {
    manually1 = false;
    manually2 = false;

    super.initState();
  }

  @override
  Widget build(BuildContext contextt) {
    return BaseWidget<CallNotifier>(
      model: CallNotifier(),
      onModelReady: (model) => model.init("${widget.channelName}", context),
      builder: (context, notifier, child) {
        ///
        CommonConstants.socket.once("call_disconnected_manually", (data) async {
          if (manually1 == false) {
            manually1 = true;
            CommonConstants.isCallConnected = false;
            await notifier.endCall(context);
            if (!callRejected) {
              Fluttertoast.showToast(msg: "Call Ended");
            }
            Get.back();
            // await flutterLocalNotificationsPlugin.cancel(1);
            CommonConstants.socket.emit('leave_room', CommonConstants.room);
            await updateDuration(CommonConstants.memberCallLogId, data ?? '');
            print("========== on call_disconnected_manually ====");
            print('userID:::::::::: :- ${CommonConstants.callerIdforStatusChange}');
          }
        });

        ///
        CommonConstants.socket.once("balance_not_ok", (data) async {
          if (manually2 == false) {
            manually2 = true;
            CommonConstants.isCallConnected = false;
            await notifier.endCall(context);
            Fluttertoast.showToast(msg: "Call Ended");
            Get.back();
            CommonConstants.socket.emit('leave_room', CommonConstants.room);
            await updateDuration(CommonConstants.memberCallLogId, data ?? '');
            print("========== on balance_not_ok ====");
            print('userID:::::::::: :- ${CommonConstants.callerIdforStatusChange}');
          }
        });

        ///
        CommonConstants.socket.once('call_rejected', (data) {
          _onCallRejected(notifier);
        });

        ///
        return Scaffold(
          // key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Video Call'),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: Stack(
              children: <Widget>[
                _viewRows(notifier),
                _panel(notifier),
                _toolbar(notifier),
                // Text("data",style: TextStyle(fontSize: 25,color: Colors.red),)
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateDuration(int calllogid, String duration) async {
    var response = await API().updateDuration(calllogid, duration);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
    } else {
      Fluttertoast.showToast(
          msg: "updateDuration API :- ${response.statusCode} :- $res");
    }
  }
}
