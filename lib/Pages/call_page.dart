import 'dart:convert';
import 'dart:io';

import 'package:astro/Agora%20Functions/Video%20Call/screens/home/home_model.dart';
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Widgets/user_listtile_design.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  bool lowBalance = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
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
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    side: BorderSide(width: 1, color: Colors.black38)),
                child: UserListTile(
                  userName: "${widget.userList[index]['name']}",
                  imageURL: '${widget.userList[index]['photo']}',
                  designation:widget.userList[index]['member'] == null?'No detail':
                      "${widget.userList[index]['member']['about_me'] ?? 'No detail'}",
                  languages: "${widget.userList[index]['sex'] ?? 'No detail'}",

                  ///used gender instead of language
                  experience:widget.userList[index]['member']== null?'No detail':
                      "${widget.userList[index]['member']['achievements'] ?? 'No detail'}",

                  ///used achievement instead of experience
                  charge:widget.userList[index]['member']== null?'No detail':
                      '₹ ${widget.userList[index]['member']['call_rate'] ?? '0'}/min',
                  totalnum: "12456",
                  waitingstatus: astroStatus == "no" ? "wait time - 4m" : "",
                  btncolor: widget.userList[index]['available'] == "yes"
                      ? MaterialStateProperty.all<Color>(Colors.green)
                      : MaterialStateProperty.all<Color>(Colors.red),
                  btnbordercolor: widget.userList[index]['available'] == "yes"
                      ? Colors.green
                      : Colors.red,
                  onTapImage: () {},
                  onTapOfTile: () {},
                  callbtnclick: () async {
                    if (widget.userList[index]['available'] == "yes") {
                      setState(() {
                        CommonConstants.receiverIdforSendNotification =
                            widget.userList[index]['id'];
                        CommonConstants.memberCallCharge = double.parse(
                            widget.userList[index]['member']['call_rate'] ?? 0);
                      });
                      await startVideoCallforCheckbalanceStatus(
                              widget.userList[index]['member']['call_rate'] ??
                                  0)
                          .whenComplete(() {
                        _showCallClickDialog(
                            _scaffoldKey.currentContext,
                            lowBalance
                                ? "Minimum balance of 5\nminutes (INR ${double.parse(widget.userList[index]['member']['call_rate']) * 5}) is\nrequired to start call with\n${widget.userList[index]['name']}"
                                : "Start Video Call Now ?",
                            widget.userList[index]['id'] ?? 0,
                            homeNotifier,
                            index);
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "${widget.userList[index]['name']} is on another call,please wait!!!");
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showCallClickDialog(
      context, String dialoguetext, int userID, homeNotifier, index) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Center(
                  child: Text(dialoguetext,style: GoogleFonts.muli(),),
                ),
              ],
            ),
          ),
          contentTextStyle: GoogleFonts.muli(
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
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _build_btn_of_dialogue("Cancel", Colors.black,
                              () async {
                            Navigator.pop(context);
                          }),
                          lowBalance
                              ? _build_btn_of_dialogue(
                                  "Recharge",
                                  Colors.black,
                                  () async {
                                    Navigator.pop(context);
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (builder) =>
                                            const AddMoneyPage(),
                                      ),
                                    );
                                  },
                                )
                              : _build_btn_of_dialogue(
                                  "VideoCall", Colors.black, () async {
                                  setState(() {
                                    CommonConstants.calljoinername =
                                        widget.userList[index]['name'];
                                    CommonConstants.receiverFCMToken =
                                        widget.userList[index]['fcm_token'] ??
                                            0;
                                  });
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'example.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      print('internet connected');

                                      await startVideoCall(
                                          homeNotifier,
                                          userID,
                                          widget.userList[index]['member']
                                                  ['call_rate'] ??
                                              0,
                                          widget.userList[index]['id'] ?? 0);

                                      ///

                                      CommonConstants.socket.once('no_data',
                                          (data) {
                                        Fluttertoast.showToast(
                                            msg: data.toString());
                                        print(
                                            "on call no_data connection is :-${CommonConstants.socket.connected}");
                                      });

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
      print("token generated successfully :- $res");
    } else {
      Fluttertoast.showToast(
          msg: "createToken API :- ${response.statusCode} :- $res");
    }
  }

  Future<void> startVideoCall(
      homeNotifier, userID, String cCharge, int receiverID) async {
    setState(() {
      checkingbalancebool = true;
    });
    var response = await API().startVideoCallAPI(cCharge);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        checkingbalancebool = false;
      });
      Navigator.pop(context);
      if (res['message'] == "no_data") {
        setState(() {
          lowBalance = true;
        });
        Fluttertoast.showToast(msg: "${res['data']['message']}");
      } else if (res['message'] == "balance_ok") {
        print("======= balance_ok ==== chat page ${res['data']['memberId']}");
        CommonConstants.socket.emit('join_room', res['data']['memberId'] ?? 0);
        setState(() {
          CommonConstants.receiverId = res['data']['memberId'] ?? 0;
          CommonConstants.room = res['data']['memberId'] ?? 0;
        });
        await createToken("$userID").whenComplete(() async {
          await createCallLog(
                  CommonConstants.userID,
                  CommonConstants.outgoingCall,
                  CommonConstants.userIsMember,
                  receiverID)
              .whenComplete(() async {
            homeNotifier.onJoin(
                _scaffoldKey.currentContext, Agora.Channel_name);
          });
          await sendNotification();
        });
        setState(() {
          lowBalance = false;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "startVideoCall API :- ${response.statusCode} :- $res");
    }
  }

  Future<void> startVideoCallforCheckbalanceStatus(String cCharge) async {
    var response = await API().startVideoCallAPI(cCharge);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      if (res['message'] == "no_data") {
        setState(() {
          lowBalance = true;
        });
      } else if (res['message'] == "balance_ok") {
        print("======= balance_ok ==== chat page ${res['data']['memberId']}");
        setState(() {
          lowBalance = false;
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
  }

  Future<void> sendNotification() async {
    var response = await API().send_notification();
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    print(res.toString());

    if (statusCode == 200) {
    } else {
      Fluttertoast.showToast(
          msg: "Send Notification API :- ${response.statusCode} :- $res");
    }
  }

  Future<void> createCallLog(
      int userID, String callType, bool isMember, int receiverID) async {
    var response =
        await API().createCallLog(userID, callType, isMember, receiverID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    print(res.toString());

    if (statusCode == 200) {
      setState(() {
        CommonConstants.callerCallLogId = res['data']['id'] ?? 0;
      });
      print(res);
    } else {
      Fluttertoast.showToast(
          msg: "createCallLog API :- ${response.statusCode} :- $res");
    }
  }

  SizedBox _build_btn_of_dialogue(String btnname, Color color, Function ontap) {
    return SizedBox(
      height: CommonConstants.device_height * 0.05,
      width: CommonConstants.device_width * 0.20,
      child: ElevatedButton(
          child: Text(btnname,
              style: GoogleFonts.muli(fontSize: 9, fontWeight: FontWeight.w300)),
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
}
