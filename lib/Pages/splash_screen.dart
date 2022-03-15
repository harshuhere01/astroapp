
import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:astro/Pages/login_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    pushFCMtoken();
    navigatetoDashBoard();
    checkPermission();
  }

  // Future<void> generateRandomUIDforVideoCall() async {
  //   var uuid = const Uuid();
  //   var v4 = uuid.v4();
  //   print("Random UUID is :- $v4");
  //   setState(() {
  //     Agora.UUID = v4;
  //   });
  // }

  Future<void> navigatetoDashBoard() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('email');
    CommonConstants.userID = prefs.getInt('id') ?? 0;
    if (key != null && key != "") {
       await getSingelUser();
       await changeAvailabilty(CommonConstants.userID,"yes");
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const HomePage()),
            (route) => false);
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const LogInPage()),
            (route) => false);
      });
    }
  }
  Future<void> changeAvailabilty(int userID, String status) async {
    var response = await API().changeAvailabilty(userID, status);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      // Fluttertoast.showToast(msg: res['message']);
    } else {
      Fluttertoast.showToast(
          msg: "changeAvailabilty API :- ${response.statusCode} :- $res");
    }
  }


  Future<void> getSingelUser() async {
    var response = await API().getSingelUser(CommonConstants.userID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        CommonConstants.userIsMember = res['data']['isMember']??false;
        CommonConstants.userCallCharge = double.parse(res['data']['call_rate'] ?? 0.00);
             });
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error From Splash Screen :- ${response.statusCode.toString()}");
    }
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
    setState(() {
      CommonConstants.userFCMToken = token;
    });
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
}
