import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;
  String? userid;

  @override
  void initState() {
    super.initState();
    pushFCMtoken();
    initMessaging();
    // generateRandomUIDforVideoCall();
    navigatetoDashBoard();

    AwesomeNotifications().actionStream.listen((receivedNotifiction) {
      if (receivedNotifiction.buttonKeyPressed == "ACCEPT") {
        print("Call Accept");
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => AddMoneyPage()));
      } else if (receivedNotifiction.buttonKeyPressed == "CANCEL") {
        print("Call Reject");
      }
    });
    checkPermission();
  }

  Future<void> generateRandomUIDforVideoCall() async {
    var uuid = const Uuid();
    var v4 = uuid.v4();
    print("Random UUID is :- $v4");
    setState(() {
      Agora.UUID = v4;
    });
  }

  checkPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      print("Checkk == $isAllowed");
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void notify() async {
    AwesomeNotifications().createNotification(
        actionButtons: [
          NotificationActionButton(key: "CANCEL", label: "CANCEL"),
          NotificationActionButton(
            key: "ACCEPT",
            label: "ACCEPT",
          )
        ],
        // schedule: NotificationInterval(
        //     interval: 45, timeZone: localTimeZone, repeats: true),
        content: NotificationContent(
            fullScreenIntent: true,
            wakeUpScreen: true,
            locked: true,
            // autoCancel: true,
            id: 10,
            channelKey: 'basic_channel',
            title: "Incoming call",
            body: "Incoming call from name",
            summary: "Hello"));
  }

  void pushFCMtoken() async {
    String? token = await messaging.getToken();
    print("The Token Is:-" + token!);
    CommonConstants.MobileTokenNotifiaction = token;
  }

  void initMessaging() {
    var androiInit =
        const AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
    var iosInit = const IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification.initialize(initSetting);
    var androidDetails = const AndroidNotificationDetails("1", "channelName",
        importance: Importance.high, priority: Priority.high);
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Fluttertoast.showToast(msg: 'A new onMessageOpenedApp event was published! :- ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print('gefwgefwe' + message.data.toString());
      //Notify();

      if (notification != null && android != null) {
        fltNotification.show(notification.hashCode, notification.title,
            notification.body, generalNotificationDetails);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp");
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(BuildContext context) async {
    //print('message from background handler');
    //print("Handling a background message: ${message.messageId}");
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => AddMoneyPage()));
  }

  List<dynamic>? userList;
  final String apiUrl = "https://randomuser.me/api/?results=50";

  fetchUsers() async {
    var response = await API().fetchUsers();
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      ///Fluttertoast.showToast(msg: res.toString());
      userList = res;
      print(userList.toString());
    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    CommonConstants.device_width = MediaQuery.of(context).size.width;
    CommonConstants.device_height = MediaQuery.of(context).size.height;

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
            ),
          ),
          (route) => false);
    });
  }
}
