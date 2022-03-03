import 'dart:convert';
import 'dart:io';

import 'package:astro/Agora%20Functions/Video%20Call/screens/home/home_model.dart';
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Widgets/user_listtile_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/src/darty.dart';

class CallPage extends StatefulWidget {
  CallPage({
    Key? key,
    this.userList,
  }) : super(key: key);
  var userList;

  @override
  State<CallPage> createState() => _CallPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _CallPageState extends State<CallPage> {
  String astroStatus = "yes";
  bool checkingbalancebool = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog(context);
        return false;
      },
      child: Consumer(
        builder: (context, HomeNotifier homeNotifier, child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.grey[200],
            body: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 5,
                        child: UserListTile(
                          userName: "${widget.userList[index]['name']}",
                          imageURL: '${widget.userList[index]['photo']}',
                          designation: "Astrologer",
                          languages: "Gujarati,Hindi,English",
                          experience: "10 Years",
                          charge: '₹ 50/min',
                          totalnum: "12456",
                          waitingstatus:
                              astroStatus == "no" ? "wait time - 4m" : "",
                          btncolor: widget.userList[index]['available'] == "yes"
                              ? MaterialStateProperty.all<Color>(Colors.green)
                              : MaterialStateProperty.all<Color>(Colors.red),

                          btnbordercolor:
                              widget.userList[index]['available'] == "yes"
                                  ? Colors.green
                                  : Colors.red,

                          onTapImage: () {},
                          onTapOfTile: () {},
                          callbtnclick: () async {
                            if (widget.userList[index]['available'] == "yes") {
                            setState(() {
                              CommonConstants.receiverIdforSendNotification =
                                  widget.userList[index]['id'];
                            });
                            // await socketConnectToServer().whenComplete(() {
                            _showCallClickDialog(
                                _scaffoldKey.currentContext,
                                "Minimum balance of 5\nminutes (INR 90.0) is\nrequired to start call with\n${widget.userList[index]['u_name']}",
                                "${widget.userList[index]['id']}",
                                homeNotifier,
                                index);
                            // });
                            // }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Member is on another call");
                            }
                          },
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  void _showCallClickDialog(
      context, String dialoguetext, String userID, homeNotifier, index) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (
        BuildContext context,
      ) {
        return  AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(dialoguetext),
              ],
            ),
          ),
          contentTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          actionsPadding: const EdgeInsets.all(10),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                checkingbalancebool
                    ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ))
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _build_btn_of_dialogue("Cancel", Colors.black, () async {
                      // CommonConstants.socket.dispose();
                      Navigator.pop(context);
                    }),
                    _build_btn_of_dialogue("Recharge", Colors.black, () async {
                      Navigator.pop(context);
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const AddMoneyPage()));
                    }),
                    _build_btn_of_dialogue("VideoCall", Colors.black, () async {
                      setState(() {
                        CommonConstants.receiverFCMToken =
                            widget.userList[index]['fcm_token'];
                      });
                      try {
                        final result =
                            await InternetAddress.lookup('example.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          print('internet connected');

                          await startVideoCall(homeNotifier, userID);

                          ///
                          // CommonConstants.socket.emit('start_video_call', {
                          //   "c_charge": 50,
                          //   "id": CommonConstants.socketID,
                          //   "userId": CommonConstants.userID,
                          //   // logged in user ID
                          //   "uid": userID
                          //   // member ID / Receiver ID
                          // });

                          ///
                          ///
                          CommonConstants.socket.once('no_data', (data) {
                            Fluttertoast.showToast(msg: data.toString());
                            // CommonConstants.socket.dispose();
                            print(
                                "on call no_data connection is :-${CommonConstants.socket.connected}");
                          });

                          ///
                          ///
                          // CommonConstants.socket.once("balance_ok", (data) async {
                          //   print(
                          //       "========== balance_ok ==== chat page ${data['uid']}");
                          //   CommonConstants.socket
                          //       .emit('join_room', data['uid']);
                          //   setState(() {
                          //     CommonConstants.receiverId = data['uid'];
                          //     CommonConstants.room = data['uid'];
                          //   });
                          //   await createToken(userID).whenComplete(() async {
                          //     await sendNotification().whenComplete(() =>
                          //         homeNotifier.onJoin(
                          //             _scaffoldKey.currentContext,
                          //             Agora.Channel_name));
                          //   });
                          // });

                          ///

                        }
                      } on SocketException catch (_) {
                        Fluttertoast.showToast(
                            msg:
                                '"There is no internet connection , please turn on your internet."');
                      }
                    }),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],

        );
      },
    );
  }

  Future<void> createToken(String userID) async {
    var response = await API().createToken(userID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      await setAgoraVariables(res);
      // await calculateTime(uMobile, cCharge, userID);
      print("token generated successfully :- $res");
    } else {
      Fluttertoast.showToast(
          msg: "createToken API :- ${response.statusCode} :- $res");
    }
  }

  Future<void> startVideoCall(homeNotifier, userID) async {
    setState(() {
      checkingbalancebool = true;
    });
    var response = await API().startVideoCallAPI();
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        checkingbalancebool = false;
      });
      Navigator.pop(context);
      if (res['message'] == "no_data") {
        Fluttertoast.showToast(msg: res['data']['message']);
      } else if (res['message'] == "balance_ok") {
        print("======= balance_ok ==== chat page ${res['data']['memberId']}");
        CommonConstants.socket.emit('join_room', res['data']['memberId']);
        setState(() {
          CommonConstants.receiverId = res['data']['memberId'];
          CommonConstants.room = res['data']['memberId'];
        });
        await createToken(userID).whenComplete(() async {
          await sendNotification().whenComplete(() => homeNotifier.onJoin(
              _scaffoldKey.currentContext, Agora.Channel_name));
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "startVideoCall API :- ${response.statusCode} :- $res");
    }
  }

  // calculateTime(String uMobile, String cCharge, String userID) async {
  //   var response = await API().calculateTime(uMobile, cCharge);
  //   int statusCode = response.statusCode;
  //   String responseBody = response.body;
  //   var res = jsonDecode(responseBody);
  //   if (statusCode == 200) {
  //     Fluttertoast.showToast(msg: "CalculateTime API $res");
  //     var emitdata = {
  //       "u_mobile": "9601603611",
  //       "c_charge": 50,
  //       "id": CommonConstants.socketID,
  //       "room": 1,
  //       "uid": userID
  //     };
  //     CommonConstants.socket.emit('start_video_call', emitdata);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "CalculateTime API Error${response.statusCode.toString()}");
  //   }
  // }

  Future<void> setAgoraVariables(res) async {
    setState(() {
      Agora.APP_ID = res["appId"];
      Agora.UUID = res['uid'];
      Agora.Channel_name = res['channel'];
      Agora.Token = res['token'];
    });
    // send_notification();
  }

  Future<void> sendNotification() async {
    var response = await API().send_notification();
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    print(res.toString());

    if (statusCode == 200) {
      // Fluttertoast.showToast(msg: "Send Notification :- $res");
    } else {
      Fluttertoast.showToast(
          msg: "Send Notification API :- ${response.statusCode} :- $res");
    }
  }

  SizedBox _build_btn_of_dialogue(String btnname, Color color, Function ontap) {
    return SizedBox(
      height: CommonConstants.device_height * 0.05,
      width: CommonConstants.device_width * 0.20,
      child: ElevatedButton(
          child: Text(btnname,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            ontap();
          }),
    );
  }

  void _showMyDialog(context) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: const Text('Exit app'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                CommonConstants.socket.dispose();
                SystemNavigator.pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
