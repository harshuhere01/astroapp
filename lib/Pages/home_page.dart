import 'dart:convert';

import 'package:astro/Agora%20Functions/Video%20Call/screens/home/home_model.dart';
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Firebase%20Services/firebase_auth_service.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/Drawer%20Pages/profile_page.dart';
import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Pages/call_page.dart';
import 'package:astro/Pages/chat_page.dart';
import 'package:astro/Pages/login_page.dart';
import 'package:astro/Widgets/tab_button.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/src/darty.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;
  int _selectedPage = 0;
  bool isPageSelected = false;
  PageController _pageController = PageController(
    keepPage: true,
  );
  String? userName;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;
  List<dynamic>? userList;

  String? photo;
  String? name;
  String? email;
  String? agee;
  String? genderr;
  String? mobilenumber;

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  initState() {
    _pageController = PageController();
    initMessaging();
    getdisplayName();
    CommonConstants.socket.on('change_status', (data) {
      print(
          "change_status :-----------------------------------------------$data");
      getAllMember();
    });
    super.initState();
  }

  @override
  void dispose() {
    CommonConstants.listened = true;
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final age = prefs.getString('age') == "null" ? '' : prefs.getString('age');
    final gender =
        prefs.getString('sex') == "null" ? '' : prefs.getString('sex');
    final mobile =
        prefs.getString('mobile') == "null" ? '' : prefs.getString('mobile');
    // setState(() {
    //   photo = prefs.getString('photo');
    //   name = "${prefs.getString('name')}";
    //   email = "${prefs.getString('email')}";
    //   agee = "$age";
    //   genderr = "$gender";
    //   mobilenumber = "$mobile";
    // });
  }

  Future<void> getAllMember() async {
    await socketConnectToServer();
    var response = await API().getAllMember(CommonConstants.userID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        userList = res['data'];
      });
      print(userList.toString());
      await getUserDetails();
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error :- ${response.statusCode.toString()}");
    }
  }

  Future<void> getSingelUser() async {
    var response = await API().getSingelUser(CommonConstants.userID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        photo = res['data']['photo'];
        name = res['data']['name'];
        email = res['data']['email'];
        agee = res['data']['age'];
        genderr = res['data']['sex'];
        mobilenumber = res['data']['mobile'];
      });
      print(userList.toString());
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error :- ${response.statusCode.toString()}");
    }
  }

  Future<void> socketConnectToServer() async {
    try {
      print("socket connection process started");
      CommonConstants.socket.connect();
      CommonConstants.socket.onConnect((data) {
        setState(() {
          CommonConstants.socketID = "${CommonConstants.socket.id}";
        });
        print("Socket Connection :-:" +
            CommonConstants.socket.connected.toString());
      });
    } catch (e) {
      print("socket_error:" + e.toString());
    }
  }

  Future<void> getdisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name');
      CommonConstants.userID = prefs.getString('id')!;
      CommonConstants.userName = prefs.getString('name')!;
      CommonConstants.userEmail = prefs.getString('email')!;
      CommonConstants.userAge = prefs.getString('age')!;
      CommonConstants.userGender = prefs.getString('sex')!;
      CommonConstants.userMobilenumber = prefs.getString('mobile')!;
      CommonConstants.userPhoto = prefs.getString('photo')!;
    });
    await getAllMember();
  }

  handleNotificationEvents(homeNotifier) {
    AwesomeNotifications().actionStream.listen((receivedNotifiction) async {
      if (receivedNotifiction.buttonKeyPressed == "ACCEPT") {
        homeNotifier.onJoin(context, CommonConstants.joiningchannelName);
        print("Call Accepted");
      } else if (receivedNotifiction.buttonKeyPressed == "CANCEL") {
        print("Call Rejected");
      }
    });
  }

  Future<void> connectSocket() async {
    CommonConstants.socket.connect();
    setState(() {
      CommonConstants.socketID = "${CommonConstants.socket.id}";
    });
  }

  void initMessaging() {
    var androidInit =
        const AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
    var iosInit = const IOSInitializationSettings();
    var initSetting =
        InitializationSettings(android: androidInit, iOS: iosInit);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification.initialize(initSetting);
    var androidDetails = const AndroidNotificationDetails(
      "1",
      "basic_channel",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      fullScreenIntent: true,
      enableVibration: true,
      autoCancel: false,
    );
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print('FirebaseMessaging.onMessage.listen' + message.data.toString());

      if (notification != null && android != null) {
        setState(() {
          CommonConstants.receiverId = message.data['receiverId'];
          CommonConstants.callerId = message.data['callerId'];
          CommonConstants.room = message.data['receiverId'];
          CommonConstants.joiningchannelName = message.data['channelName'];
          Agora.Token = message.data['agoraToken'];
          Agora.APP_ID = message.data['app_id'];
        });
        // if(CommonConstants.socket.connected){
        //   await notify();
        // }
        // else {
        //   await connectSocket();
        await notify();
        // }

        ///Awesome Notification
        print(
            "Incoming Notification :-Title - ${notification.title}, Body - ${notification.body}, BodyLocARGS - ${notification.bodyLocArgs}");

        /// Normal Notification
        // fltNotification.show(notification.hashCode, notification.title,
        //     notification.body, generalNotificationDetails);

      }
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print("onMessageOpenedApp");
    // });
  }

  Future<void> notify() async {
    AwesomeNotifications().createNotification(
      actionButtons: [
        NotificationActionButton(
          key: "CANCEL",
          label: "CANCEL",
        ),
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
          category: NotificationCategory.Call,
          displayOnBackground: true,
          displayOnForeground: true,
          autoDismissible: false,
          id: 1,
          channelKey: 'basic_channel',
          title: "Incoming call",
          body: "Incoming call from name",
          summary: "Hello"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, HomeNotifier homeNotifier, child) {
      if (CommonConstants.listened == false) {
        handleNotificationEvents(homeNotifier);
        CommonConstants.listened = true;
      }
      return Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: SizedBox(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  padding: EdgeInsets.fromLTRB(
                      CommonConstants.device_height * 0.028,
                      CommonConstants.device_height * 0.15,
                      0.0,
                      CommonConstants.device_height * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                  ),
                  child: Text(
                    "$userName",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, size: 28),
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await getSingelUser().whenComplete(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            photo: photo,
                            name: name,
                            email: email,
                            age: agee,
                            gender: genderr,
                            mobile: mobilenumber,
                          ),
                        ),
                      );
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet, size: 28),
                  title: const Text(
                    'Wallet',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddMoneyPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, size: 28),
                  title: const Text(
                    'History',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, size: 28),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    await AuthClass().signOut();
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const LogInPage()),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tapped Search")));
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tapped Settings")));
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black,
                )),
          ],
          backgroundColor: Colors.yellow[600],
          title: const Text("Call with Astrologer"),
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        body: Column(
          verticalDirection: VerticalDirection.down,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 80,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: TabButton(
                        selectedPage: _selectedPage,
                        pageNumber: 0,
                        text: "Call",
                        onPressed: () {
                          _changePage(0);
                        }),
                  ),
                  Expanded(
                    flex: 2,
                    child: TabButton(
                        selectedPage: _selectedPage,
                        pageNumber: 1,
                        text: "Chat",
                        onPressed: () {
                          _changePage(1);
                        }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (int page) {
                  setState(() {
                    _selectedPage = page;
                  });
                },
                controller: _pageController,
                children: [
                  userList == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : userList!.isEmpty
                          ? const Center(
                              child: Text(
                              "No members record found !!!",
                              style: TextStyle(color: Colors.black),
                            ))
                          : CallPage(
                              userList: userList,
                            ),
                  // userList!.isEmpty
                  //    ? const Center(
                  //        child: CircularProgressIndicator(
                  //          color: Colors.black,
                  //        ),
                  //      )
                  //    :
                  const ChatPage(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// check wallet balance button
//   Column(
//   children: [
//   Container(
//   margin: const EdgeInsets.all(10),
//   width: 200,
//   height: 40,
//   alignment: Alignment.center,
//   decoration: BoxDecoration(
//   color: Colors.yellow[600],
//   borderRadius: const BorderRadius.all(Radius.circular(10)),
//   border: Border.all(color: Colors.black87.withOpacity(0.1)),
//   ),
//   padding: const EdgeInsets.all(2),
//   child: TextButton(
//   onPressed: () async {
//   // CommonConstants.socket.emit(
//   //     'socket_connected_frontend', {"id": CommonConstants.socket.id});
//   await getWalletBalance();
// },
// child: Text(
// buttonName,
// style: const TextStyle(
// fontSize: 15,
// color: Colors.black,
// fontWeight: FontWeight.w300),
// ),
// ),
// ),
// walletBalance == null || walletBalance == ""
// ? Container()
//     : Text(
// "Your wallet Balance is : ₹ $walletBalance",
// style: const TextStyle(
// fontSize: 15,
// color: Colors.black,
// fontWeight: FontWeight.w300),
// ),
// ],
// ),

}
