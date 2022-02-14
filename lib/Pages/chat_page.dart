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

   String? astro_status;

  @override
  void initState() {
    socketConnectToServer();
    //Getastrologer();
    super.initState();
  }

  // Future<void> Getastrologer() async {
  //
  //   final uri = Uri.parse(APIConstants.BaseURL + APIConstants.GetAllUsers);
  //   final headers = {'Content-Type': 'application/json',};
  //   Map<String, dynamic> body = {
  //     "u_type":"astrologer",
  //   };
  //   String jsonBody = json.encode(body);
  //   // final encoding = Encoding.getByName('utf-8');
  //
  //   Response response = await post(
  //     uri,
  //     headers: headers,
  //     body: jsonBody,
  //     // encoding: encoding,
  //   );
  //   int statusCode = response.statusCode;
  //   String responseBody = response.body;
  //   var res = jsonDecode(responseBody);
  //
  //
  //   if (statusCode == 200) {
  //     Fluttertoast.showToast(msg: res.toString());
  //
  //   }
  //   else{
  //     Fluttertoast.showToast(msg: response.statusCode.toString());
  //   }
  // }

  Future<void> socketConnectToServer() async {
    try {
      print("socket connection process started");
      CommonConstants.socket.connect();
      CommonConstants.socket.onConnect((data) => {
            print("Socket Connection :-:" +
                CommonConstants.socket.connected.toString())
          });
      // CommonConstants.socket.emit(
      //     'socket_connected_frontend', {"id": CommonConstants.socket.id});
      CommonConstants.socket.on("socket_connected_backend", (data) {
        print(
            "Socket connection message from socket_connected_backend event :- $data ");
      });
      CommonConstants.socket.on('no_data', (data) {
        Fluttertoast.showToast(msg: data.toString());
      });
      CommonConstants.socket.on('event', (data) {
        Fluttertoast.showToast(msg: data.toString());
      });
      CommonConstants.socket.on('call_status', (data) {
        Fluttertoast.showToast(msg: "Call status = ${data['status']}");
        setState(() {
          astro_status = data['status'];
        });
      });

    } catch (e) {
      print("socket_error:" + e.toString());
    }
  }

  // for send notification
  // static Future<bool> sendFcmMessage(
  //     String title, String message, String fcmToken) async {
  //   try {
  //     var header = {
  //       "Content-Type": "application/json",
  //       "Authorization": "key=AAAApOGu0ok:APA91bFS07zT3qrfNpSpFjIVfJ_QzKc0ujfd3FTxLuLONesfgYBBV0Yh9u5Wm2jWWSsVe4fUF4tu1caGIbkzc1LvPqJOHh-Y6yXdu2HrQxE9Q8OtqXO3MTSZZfW4Lb1cYAi6-q0M8jN6",
  //     };
  //     var request = {
  //       "notification": {
  //         "title": title,
  //         "body": message,
  //         "data": Agora.APP_ID,
  //         "sound": "default",
  //         "color": "#990000",
  //
  //       },
  //       "priority": "high",
  //       "to": fcmToken,
  //     };
  //
  //     var client = new Client();
  //     var response = await client.post(
  //         Uri.parse(APIConstants.FirebaseNotificationAPI),
  //         headers: header,
  //         body: json.encode(request));
  //     return true;
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //     return false;
  //   }
  // }

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
                    astro_status: astro_status,
                    waitingstatus: astro_status == "Busy"
                            ? "wait time - 4m"
                            : "",
                    btncolor: astro_status == "Available"
                        ? MaterialStateProperty.all<Color>(Colors.green)
                        : astro_status == "Busy"
                            ? MaterialStateProperty.all<Color>(Colors.red)
                            : MaterialStateProperty.all<Color>(Colors.grey),
                    btnbordercolor: astro_status == "Available"
                        ? Colors.green
                        : astro_status == "Busy"
                            ? Colors.red
                            : Colors.grey,
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

  Future<void> createToken(String userID) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.CreateToken);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "channel_name": userID,
      "uid": "0",
      "role": "customer",
      "expire_time": "null"
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

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
    final uri =
        Uri.parse(APIConstants.BaseURL + APIConstants.send_notification);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "fcm_token": CommonConstants.MobileTokenNotifiaction,
      "channelName": Agora.Channel_name,
      "agora_token": Agora.Token,
    };
    String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      // encoding: encoding,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    print(res.toString());

    if (statusCode == 200) {
      //Fluttertoast.showToast(msg: res.toString());
    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
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
