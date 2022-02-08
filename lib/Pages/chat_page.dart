import 'dart:convert';
import 'dart:io';

import 'package:astro/Agora%20Functions/Video%20Call/screens/home/home_model.dart';
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Constant/api_constant.dart';
import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Widgets/user_listtile_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, this.itemlist}) : super(key: key);
  var itemlist;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    socketConnectToServer();
    super.initState();
  }

  Future<void> socketConnectToServer() async {
    try {
      print("socket connection process started");
      CommonConstants.socket.connect();
      CommonConstants.socket.onConnect((data) => {
            print("Socket Connection :-:" +
                CommonConstants.socket.connected.toString())
          });
      CommonConstants.socket.on("socket_connected_backend", (data) {
        print(
            "on socket connection socket_connected_backend event emitted ...$data ");
      });
    } catch (e) {
      print("socket_error:" + e.toString());
    }
  }

  static Future<bool> sendFcmMessage(
      String title, String message, String fcmToken) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        // "Authorization": "key=your_server_key",
      };
      var request = {
        "notification": {
          "title": title,
          "text": message,
          "sound": "default",
          "color": "#990000",
        },
        "priority": "high",
        "to": fcmToken,
      };

      var client = new Client();
      var response = await client.post(
          Uri.parse(APIConstants.FirebaseNotificationAPI),
          headers: header,
          body: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      print(s);
      return false;
    }
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
              itemCount: widget.itemlist.length,
              itemBuilder: (BuildContext context, int index) {
                int age = widget.itemlist[index]['dob']['age'];
                return Card(
                  elevation: 5,
                  child: UserListTile(
                    userName: "${widget.itemlist[index]['name']['first']}",
                    imageURL: widget.itemlist[index]['picture']['large'],
                    designation: "Numerology, Face Reading",
                    languages: "English, Hindi, Gujarati",
                    experience: "Exp: 15 Years",
                    charge: "₹ 60/min",
                    totalnum: "12456",
                    age: widget.itemlist[index]['dob']['age'],
                    waitingstatus: age > 60
                        ? ""
                        : age < 40
                            ? "wait time - 4m"
                            : "",
                    btncolor: age > 60
                        ? MaterialStateProperty.all<Color>(Colors.grey)
                        : age < 40
                            ? MaterialStateProperty.all<Color>(Colors.red)
                            : MaterialStateProperty.all<Color>(Colors.green),
                    btnbordercolor: age > 60
                        ? Colors.grey
                        : age < 40
                            ? Colors.red
                            : Colors.green,
                    onTapImage: () {},
                    onTapOfTile: () {},
                    callbtnclick: () {
                      _showCallClickDialog(
                          _scaffoldKey.currentContext,
                          "Minimum balance of 5\nminutes (INR 90.0) is\nrequired to start call with\n${widget.itemlist[index]['name']['first']}",
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

  void _showCallClickDialog(context, String dialoguetext, homeNotifier) async {
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
            _build_btn_of_dialogue("Cancel", Colors.black, () async {
              var nres = await sendFcmMessage("Test", "Notification from Harsh",
                  "fTZXMCcSSteGiz8I_k-xAO:APA91bGitwsJ7vXl3gThjKCHtALo1WJU34psyqtdICJLaf8g0KYLkbSmJfpwkzE6ihB92998H7jPk2MANxX2s8_w-0wn1CRzRJEse89fQDjhAFyK4gK1mWyOoHdIdHjKWGv_5NLPYe8Y");
              print("Notification send :----------------$nres");
              Navigator.pop(context);
            }),
            _build_btn_of_dialogue("Recharge", Colors.black, () async {
              Navigator.pop(context);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => AddMoneyPage()));
            }),
            _build_btn_of_dialogue("VideoCall", Colors.black, () async {
              try {
                final result = await InternetAddress.lookup('example.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  print('internet connected');
                  Navigator.pop(context);
                  // var emitdata = {"u_mobile": "9601603611", "c_charge": 50};
                    CommonConstants.socket.emit('start_video_call', {"u_mobile": "9601603611", "c_charge": 50});
                    CommonConstants.socket.on("balance_ok", (data)
                    {
                      print(
                          "=========balance ok ===============================$data");

                      if (data == true) {
                        if (CommonConstants.CallDone == '' ||
                            CommonConstants.CallDone == null ||
                            CommonConstants.CallDone.isEmpty) {
                          CommonConstants.CallDone = data.toString();
                          homeNotifier.onJoin(_scaffoldKey.currentContext, Agora.Channel_name);

                        } else {
                          print(
                              "=========balance ok ===============================ELSSSSSS$data");
                        }
                      } else {
                        print("Dialog Open karo");
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
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  // Future<void> CalculateTime() async {
  //   print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
  //   final uri = Uri.parse(APIConstants.BaseURL + APIConstants.CalculateTime);
  //   final headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   Map<String, dynamic> body = {
  //     "u_mobile": "9601603611",
  //     "c_charge": 50,
  //   };
  //   String jsonBody = json.encode(body);
  //   final encoding = Encoding.getByName('utf-8');
  //
  //   Response response = await post(
  //     uri,
  //     headers: headers,
  //     body: jsonBody,
  //     encoding: encoding,
  //   );
  //
  //   int statusCode = response.statusCode;
  //   String responseBody = response.body;
  //   var res = jsonDecode(responseBody);
  //
  //   Fluttertoast.showToast(msg: "CalculateTime API $responseBody");
  //
  //   if (statusCode == 200) {
  //     Fluttertoast.showToast(msg: "CalculateTime API $res");
  //   } else {
  //     Fluttertoast.showToast(msg: "CalculateTime API Error${response.statusCode.toString()}");
  //   }
  // }

  SizedBox _build_btn_of_dialogue(String btnname, Color color, Function ontap) {
    return SizedBox(
      height: CommonConstants.device_height * 0.05,
      width: CommonConstants.device_width * 0.21,
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
