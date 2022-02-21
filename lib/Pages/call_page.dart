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

class CallPage extends StatefulWidget {
  CallPage({Key? key, this.itemlist}) : super(key: key);
  var itemlist;

  @override
  State<CallPage> createState() => _CallPageState();
}
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class _CallPageState extends State<CallPage> {
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
              itemCount: widget.itemlist.length,
              itemBuilder: (BuildContext context, int index) {
                int age = int.parse(widget.itemlist[index]['status']);
                return Card(
                  elevation: 5,
                  child: UserListTile(
                    userName: "${widget.itemlist[index]['u_name']}",
                    imageURL:
                    'https://randomuser.me/api/portraits/med/women/5.jpg',
                    designation: widget.itemlist[index]['u_type'],
                    languages: widget.itemlist[index]['languages'],
                    experience: widget.itemlist[index]['experience'],
                    charge: '₹ ' +
                        widget.itemlist[index]['charge_per_minute'] +
                        '/min',
                    totalnum: "12456",
                    astro_status: "astro_status",
                    waitingstatus: age == 0
                        ? "wait time - 4m"
                        : age == 0
                        ? "wait time - 4m"
                        : "",
                    btncolor: age == 1
                        ? MaterialStateProperty.all<Color>(Colors.green)
                        : age == 2
                        ? MaterialStateProperty.all<Color>(Colors.grey)
                        : MaterialStateProperty.all<Color>(Colors.red),
                    btnbordercolor: age == 1
                        ? Colors.green
                        : age == 2
                        ? Colors.grey
                        : Colors.red,
                    onTapImage: () {},
                    onTapOfTile: () {},
                    callbtnclick: () {
                      _showCallClickDialog(
                          _scaffoldKey.currentContext,
                          "Minimum balance of 5\nminutes (INR 90.0) is\nrequired to start call with\n${widget.itemlist[index]['u_name']}",
                          "${widget.itemlist[index]['id']}",
                          homeNotifier);
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
      context, String dialoguetext, String userID, homeNotifier) async {
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
                Text(dialoguetext),
              ],
            ),
          ),
          contentTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          actionsPadding: const EdgeInsets.all(10),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _build_btn_of_dialogue("Cancel", Colors.black, () async {
                      Navigator.pop(context);
                    }),
                    _build_btn_of_dialogue("Recharge", Colors.black, () async {
                      Navigator.pop(context);
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => AddMoneyPage()));
                    }),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _build_btn_of_dialogue("VideoCall", Colors.black, () async {
                      try {
                        final result =
                        await InternetAddress.lookup('example.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          print('internet connected');
                          Navigator.pop(context);
                          await createToken(userID).whenComplete(() {
                            var emitdata = {
                              "u_mobile": "9601603611",
                              "c_charge": 50
                            };

                            CommonConstants.socket
                                .emit('start_video_call', emitdata);
                          });
                          CommonConstants.socket.on("balance_ok", (data) {
                            print(
                                "=========balance ok ===============================$data");
                            if (data == true) {
                              if (CommonConstants.CallDone == '' ||
                                  CommonConstants.CallDone == null ||
                                  CommonConstants.CallDone.isEmpty) {
                                CommonConstants.CallDone = data.toString();
                                homeNotifier.onJoin(_scaffoldKey.currentContext,
                                    Agora.Channel_name);
                              } else {
                                print(
                                    "else part =========balance ok ===============================$data");
                              }
                            } else {
                              print("data = $data");
                            }
                          });
                          CommonConstants.socket.on("balance_not_ok", (data) {
                            print("blalance not ok ============$data");
                          });
                        }
                      } on SocketException catch (_) {
                        Fluttertoast.showToast(
                            msg:
                            '"There is no internet connection , please turn on your internet."');
                      }
                    }),
                    _build_btn_of_dialogue("Join Call", Colors.black, () async {
                      await createToken(userID).whenComplete(() {
                        homeNotifier.onJoin(
                            _scaffoldKey.currentContext, Agora.Channel_name);
                      });
                    }),
                  ],
                )
              ],
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  createToken(String userID) async {
    var response = await API().createToken(userID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      await setAgoraVariables(res);
      print("token generated successfully :- $res");
    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }

  Future<void> setAgoraVariables(res) async {
    setState(() {
      Agora.APP_ID = res["appId"];
      Agora.UUID = res['uid'];
      Agora.Channel_name = res['channel'];
      Agora.Token = res['token'];
    });
    send_notification();
  }

  Future<void> send_notification() async {
    var response = await API().send_notification();
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    print(res.toString());

    if (statusCode == 200) {
      Fluttertoast.showToast(msg: "Send Notification :- $res");
    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }


  SizedBox _build_btn_of_dialogue(String btnname, Color color, Function ontap) {
    return SizedBox(
      height: 40,
      width: 80,
      child: ElevatedButton(
          child: Text(btnname,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w300)),
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
