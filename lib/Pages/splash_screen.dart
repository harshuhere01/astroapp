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
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late AnimationController animationlogo;
  late Animation<double> animlogo;
  late AnimationController animationname;
  late Animation<double> animname;

  @override
  void initState() {
    super.initState();
    pushFCMtoken();
    checkPermission();
    animationlogo = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animlogo = CurvedAnimation(parent: animationlogo, curve: Curves.linear);

    animationname = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animname = CurvedAnimation(parent: animationlogo, curve: Curves.linear);

    animationlogo.forward();
    animationlogo.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationname.forward();
      } else if (status == AnimationStatus.dismissed) {

      }
    });

    animationname.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 800), () {
        animationname.reverse();
        animationlogo.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {

          navigatetoDashBoard();

      }
    });
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
    if (key != null && key != "") {
      // Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const HomePage()),
          (route) => false);
      // });
    } else {
      // Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const LogInPage()),
          (route) => false);
      // });
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
    // await navigatetoDashBoard();
  }

  Future<void> getPrefrences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      CommonConstants.userID = prefs.getInt('id') ?? 0;
      CommonConstants.userName = prefs.getString('name') ?? '';
      CommonConstants.userEmail = prefs.getString('email') ?? '';
      CommonConstants.userAge = prefs.getString('age') ?? '';
      CommonConstants.userGender = prefs.getString('sex') ?? '';
      CommonConstants.userMobilenumber = prefs.getString('mobile') ?? '';
      CommonConstants.userPhoto = prefs.getString('photo') ?? '';
      CommonConstants.userCallCharge = prefs.getDouble('userCallCharge') ?? 0;
      CommonConstants.userIsMember = prefs.getBool('isMember') ?? false;
    });
    await changeAvailabilty(CommonConstants.userID, "yes");
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

    ///
    await getPrefrences();

    ///
  }

  @override
  Widget build(BuildContext context) {
    CommonConstants.device_width = MediaQuery.of(context).size.width;
    CommonConstants.device_height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CommonConstants.appcolor,
      body: Stack(
        children: [
          // Opacity(
          //   opacity: 0.5,
          //   child: SizedBox(
          //     height: CommonConstants.device_height,
          //     width: CommonConstants.device_width,
          //     child: Image.asset(
          //       'asset/splash_screen_bg.jpg',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: animationlogo,
                  child: Container(
                      height: CommonConstants.device_height / 5,
                      width: CommonConstants.device_height / 5,
                      // decoration: const BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(100)),
                      //   color: Colors.yellow,
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'asset/app_logo.png',
                          color: Colors.black,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                ScaleTransition(
                  scale: animationname,
                  child: Text(
                    "FOLO",
                    style:
                    GoogleFonts.muli(color: Colors.black, fontSize: 30),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
