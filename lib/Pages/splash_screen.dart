
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:astro/Pages/login_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    super.initState();
    pushFCMtoken();
    navigatetoDashBoard();
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

  Future<void> navigatetoDashBoard() async {
    // await fetchUsers().whenComplete(() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('email');
    if (key != null && key != "") {
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
    // });
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

  Future<void> _firebaseMessagingBackgroundHandler(BuildContext context) async {
    print('message from background handler');
    print("Handling a background message:----");
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (builder) => AddMoneyPage()));
  }

  @override
  Widget build(BuildContext context) {
    CommonConstants.device_width = MediaQuery.of(context).size.width;
    CommonConstants.device_height = MediaQuery.of(context).size.height;
    buildContext = context;
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
}
