import 'dart:convert';
import 'dart:io';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Constant/api_constant.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;


  @override
  void initState() {
    super.initState();
    // loginUser();
    pushFCMtoken();
    initMessaging();
    // createTokenAPI();
    // generateRandomUIDforVideoCall();
    navigatetoDashBoard();
  }
  Future<void> generateRandomUIDforVideoCall() async {
    var uuid = Uuid();
    var v4 = uuid.v4();
    print("Random UUID is :- $v4");
    setState(() {
      Agora.UUID = v4;
    });
  }

  void pushFCMtoken() async {
    String? token = await messaging.getToken();
    print("The Token Is:--"+token!);
  }
  void initMessaging() {
    var androiInit =
    AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
    var iosInit = IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification.initialize(initSetting);
    var androidDetails = AndroidNotificationDetails("1", "channelName",importance: Importance.high,priority: Priority.high);
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        fltNotification.show(notification.hashCode, notification.title,
            notification.body, generalNotificationDetails);
      }
    });
  }

  Future<void> createTokenAPI() async {

    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.CreateToken  );
    final headers = {'Content-Type': 'application/json',};
    Map<String, dynamic> body = {
      "channel_name":"myChannel",
      "uid":Agora.UUID,
      "role":"customer",
      "expire_time":Agora.TokenExpireTime
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
    if (statusCode == 200) {
      // Fluttertoast.showToast(msg: res.toString());
      await setAgoraVariables(res).whenComplete(() {
        // Fluttertoast.showToast(msg: "variables set succssfully");
        // try{
        //   homeNotifier.onJoin(context,Agora.Channel_name);
        // }
        //     catch(e){
        //       Fluttertoast.showToast(msg: e.toString());
        //     }
      });

    }
    else{
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }

  Future<void> setAgoraVariables (res)async{
    setState(() {
      Agora.APP_ID = res["appId"];
      Agora.UUID = res['uid'];
      Agora.Channel_name = res['channel'];
      Agora.Token = res['token'];
    });
  }

  List<dynamic>? userList;

  final String apiUrl = "https://randomuser.me/api/?results=50";

  Future<void> fetchUsers() async {
    try {
      final result =
      await InternetAddress.lookup('example.com');
      if (result.isNotEmpty &&
          result[0].rawAddress.isNotEmpty) {
        print('Internet connected');
        var result = await http.get(Uri.parse(apiUrl));
        var data = json.decode(result.body)['results'];
        setState(() {
          userList = data;
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: '"There is no internet connection , please turn on your internet."');
    }

  }

  @override
  Widget build(BuildContext context) {
    CommonConstants.device_width= MediaQuery.of(context).size.width;
    CommonConstants.device_height= MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SpinKitSquareCircle(
            color: Colors.black,
            size: 100.00,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Welcome!!!",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w300, fontSize: 30),
          )
        ],
      ),
    );
  }

  void navigatetoDashBoard() async {
    await fetchUsers().whenComplete(() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (builder) => HomePage(
                    userList: userList,
                  ),),
          (route) => false);
    });
  }
}
