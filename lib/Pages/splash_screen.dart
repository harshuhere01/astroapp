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
import 'package:socket_io_client/src/darty.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;
  String? userid;
  late BuildContext buildContext;

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pushFCMtoken();
    // initMessaging();
    // generateRandomUIDforVideoCall();
    // socketConnectToServer();
    navigatetoDashBoard();
    checkPermission();
  }
  // socketConnectToServer() {
  //   try {
  //     print("socket connection process started");
  //     CommonConstants.socket.connect();
  //     CommonConstants.socket.onConnect((data) {
  //       // print("========== on socket connect");
  //       setState(() {
  //         CommonConstants.socketID = "${CommonConstants.socket.id}";
  //       });
  //       print("Socket Connection :-:" +
  //           CommonConstants.socket.connected.toString());
  //     });
  //     // CommonConstants.socket.on('call_status', (data) {
  //     //   // print("========== on call_status");
  //     //   Fluttertoast.showToast(msg: "Call status = ${data['status']}");
  //     //   setState(() {
  //     //     astroStatus = data['status'];
  //     //   });
  //     // });
  //     // CommonConstants.socket.on("socket_connected_backend", (data) {
  //     //   print(
  //     //       "========== on socket_connected_backend  :- $data ");
  //     // });
  //     // CommonConstants.socket.on('event', (data) {
  //     //   print("========== on event");
  //     //   Fluttertoast.showToast(msg: data.toString());
  //     // });
  //
  //   } catch (e) {
  //     print("socket_error:" + e.toString());
  //   }
  // }

  // void notify() async {
  //   AwesomeNotifications().createNotification(
  //     actionButtons: [
  //       NotificationActionButton(
  //         key: "CANCEL",
  //         label: "CANCEL",
  //       ),
  //       NotificationActionButton(
  //         key: "ACCEPT",
  //         label: "ACCEPT",
  //       )
  //     ],
  //     // schedule: NotificationInterval(
  //     //     interval: 45, timeZone: localTimeZone, repeats: true),
  //     content: NotificationContent(
  //         fullScreenIntent: true,
  //         wakeUpScreen: true,
  //         locked: true,
  //         category: NotificationCategory.Call,
  //         displayOnBackground: true,
  //         displayOnForeground: true,
  //         autoDismissible: false,
  //         // autoCancel: true,
  //         id: 1,
  //         channelKey: 'basic_channel',
  //         title: "Incoming call",
  //         body: "Incoming call from name",
  //         summary: "Hello"),
  //   );
  // }

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
      print("Checkk notification permission == $isAllowed");
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void pushFCMtoken() async {
    String? token = await messaging.getToken();
    print("FCM Token Is:-" + token!);
    // setState(() {
    //   CommonConstants.receiverFCMToken = token;
    // });
  }

  // void initMessaging() {
  //   var androiInit =
  //       const AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
  //   var iosInit = const IOSInitializationSettings();
  //   var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
  //   fltNotification = FlutterLocalNotificationsPlugin();
  //   fltNotification.initialize(initSetting);
  //   var androidDetails = const AndroidNotificationDetails(
  //     "1",
  //     "basic_channel",
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     playSound: true,
  //     fullScreenIntent: true,
  //     enableVibration: true,
  //     autoCancel: false,
  //   );
  //   var iosDetails = const IOSNotificationDetails();
  //   var generalNotificationDetails =
  //       NotificationDetails(android: androidDetails, iOS: iosDetails);
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     Fluttertoast.showToast(msg: 'Incoming Notification data is :- ${message.data}');
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //
  //     print('FirebaseMessaging.onMessage.listen' + message.data.toString());
  //
  //     if (notification != null && android != null) {
  //       /// Normal Notification
  //       // fltNotification.show(notification.hashCode, notification.title,
  //       //     notification.body, generalNotificationDetails);
  //       ///Awesome Notification
  //       print("Incoming Notification :-Title - ${notification.title}, Body - ${notification.body}, BodyLocARGS - ${notification.bodyLocArgs}");
  //       notify();
  //
  //     }
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print("onMessageOpenedApp");
  //   });
  // }

  Future<void> _firebaseMessagingBackgroundHandler(BuildContext context) async {
    //print('message from background handler');
    // print("Handling a background message: ${message.messageId}");
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
    buildContext=context;
    return Scaffold(
      // key: _scaffoldKey,
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
