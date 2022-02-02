import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
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
    generateRandomUIDforVideoCall();
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

  List<dynamic>? userList;

  final String apiUrl = "https://randomuser.me/api/?results=50";

  Future<void> fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    var data = json.decode(result.body)['results'];
    setState(() {
      userList = data;
    });
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

  // void loginUser() {}
}
