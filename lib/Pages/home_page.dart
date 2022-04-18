import 'dart:convert';

import 'package:astro/Agora%20Functions/Video%20Call/screens/home/home_model.dart';
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Firebase%20Services/firebase_auth_service.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/Drawer%20Pages/Call%20History/callHistoryPage.dart';
import 'package:astro/Pages/Drawer%20Pages/login_screen.dart';
import 'package:astro/Pages/Drawer%20Pages/profile_page.dart';
import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Pages/call_page.dart';
import 'package:astro/Pages/chat_page.dart';
import 'package:astro/Pages/login_page.dart';
import 'package:astro/Widgets/tab_button.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  /// for Page View
  int _selectedPage = 0;
  bool isPageSelected = false;
  PageController _pageController = PageController(
    keepPage: true,
  );

  /// others
  String? userName;
  late FlutterLocalNotificationsPlugin fltNotification;
  List<dynamic>? userList;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
    socketConnectandGetMembers();
    CommonConstants.socket.on('change_status', (data) {
      print("change_status :--------home page1----------$data");
      getAllMember();
    });
    CommonConstants.socket.on('refresh_list', (data) {
      print("change_status :-----------home page2---------$data");
      getAllMember();
    });
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    super.initState();
  }

  @override
  void dispose() {
    if(mounted){
    CommonConstants.listened = true;
    _pageController.dispose();}
    super.dispose();
  }

  Future<void> createCallLog(
      int userID, String callType, bool isMember, int receiverID) async {
    var response =
        await API().createCallLog(userID, callType, isMember, receiverID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    print(res.toString());

    if (statusCode == 200) {
      setState(() {
        CommonConstants.memberCallLogId = res['data']['id'] ?? 0;
      });
    } else {
      Fluttertoast.showToast(
          msg: "createCallLog API :- ${response.statusCode} :- $res");
    }
  }

  Future<void> getAllMember() async {
    var response = await API().getAllMember(CommonConstants.userID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      if(mounted) {
        setState(() {
          userList = res['data'];
        });
      }
      print(userList.toString());
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error :- ${response.statusCode.toString()}");
    }
  }

  /// ------------------------------- commented on 12-04-
  // Future<void> socketConnectToServer() async {
  //   try {
  //     print("socket connection process started");
  //     CommonConstants.socket.connect();
  //     CommonConstants.socket.onConnect((data) {
  //       setState(() {
  //         CommonConstants.socketID = "${CommonConstants.socket.id}";
  //       });
  //       print("Socket Connection :-:" +
  //           CommonConstants.socket.connected.toString());
  //     });
  //   } catch (e) {
  //     print("socket_error:" + e.toString());
  //   }
  // }

  Future<void> socketConnectandGetMembers() async {
    /// ------------------------------- commented on 12-04-
    // await socketConnectToServer();
    await getAllMember();
    print("userID:-${CommonConstants.userID}");
    print("userName:-${CommonConstants.userName}");
    print("userEmail:-${CommonConstants.userEmail}");
    print("userAge:-${CommonConstants.userAge}");
    print("userGender:-${CommonConstants.userGender}");
    print("userMobilenumber:-${CommonConstants.userMobilenumber}");
    print("userPhoto:-${CommonConstants.userPhoto}");
    print("userCallCharge:-${CommonConstants.userCallCharge}");
    print("userIsMember:-${CommonConstants.userIsMember}");
  }

  handleNotificationEvents(homeNotifier) {
    if(mounted){
    AwesomeNotifications().actionStream.listen((receivedNotifiction) async {
      if (receivedNotifiction.buttonKeyPressed == "ACCEPT") {
        homeNotifier.onJoin(context, CommonConstants.joiningchannelName);

        print("Call Accepted from home page");
      } else if (receivedNotifiction.buttonKeyPressed == "CANCEL") {
        CommonConstants.socket.emit(
            'call_rejection', {"socketId": CommonConstants.callerSocketId});

        Fluttertoast.showToast(msg: "Call rejected");
        print("Call Rejected from home page");
      }
    });
  }}

  Future<void> initMessaging() async {
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
      importance: Importance.max,
      priority: Priority.max,
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
      await createCallLog(
          CommonConstants.userID,
          CommonConstants.incomingCall,
          CommonConstants.userIsMember,
          int.parse(message.data['callerId'] ?? 0));
      if (notification != null && android != null) {
        try {
          CommonConstants.socket
              .emit('join_room', int.parse(message.data['receiverId'] ?? 0));
        } catch (e) {
          Fluttertoast.showToast(msg: "Error while emit join_room :- $e");
        }

        setState(() {
          CommonConstants.receiverId =
              int.parse(message.data['receiverId'] ?? 0);
          CommonConstants.callerId = int.parse(message.data['callerId'] ?? 0);
          CommonConstants.callerIdforStatusChange = int.parse(message.data['callerId'] ?? 0);
          CommonConstants.callerSocketId = message.data['socketId'] ?? '';
          CommonConstants.room = int.parse(message.data['receiverId'] ?? 0);
          CommonConstants.calljoinername = message.data['username'] ?? '';
          CommonConstants.callerCallLogId =
              int.parse(message.data['callLogId'] ?? 0);
          CommonConstants.joiningchannelName =
              message.data['channelName'] ?? '';
          Agora.Token = message.data['agoraToken'] ?? '';
          Agora.APP_ID = message.data['app_id'] ?? '';
        });

        ///
        await notify(message);

        ///Awesome Notification
        // print(
        //     "Incoming Notification :-Title - ${notification.title}, Body - ${notification.body}, BodyLocARGS - ${notification.bodyLocArgs}");

        /// Normal Notification
        // fltNotification.show(notification.hashCode, message.data['username'],
        //     message.data['username'], generalNotificationDetails);

        CommonConstants.socket.once("call_cancel", (data) async {
          await flutterLocalNotificationsPlugin.cancel(1);
          Fluttertoast.showToast(
              msg: "Call canceled by ${message.data['username']}");
        });
      }
    });
  }

  Future<void> notify(message) async {
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
          body: "Incoming call from ${message.data['username']}",
          summary: "Hello"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog(context);
        return false;
      },
      child: Consumer(builder: (context, HomeNotifier homeNotifier, child) {
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
                      CommonConstants.device_height * 0.10,
                      0.0,
                      CommonConstants.device_height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: CommonConstants.appcolor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              width: CommonConstants.device_width / 7.5,
                              height: CommonConstants.device_width / 7.5,
                              placeholder:
                                  const AssetImage("asset/placeholder.png"),
                              image: NetworkImage(CommonConstants.userPhoto),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          CommonConstants.userName,
                          style: GoogleFonts.muli(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, size: 28),
                    title: Text(
                      'Profile',
                      style: GoogleFonts.muli(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet, size: 28),
                    title: Text(
                      'Wallet',
                      style: GoogleFonts.muli(
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
                    title: Text(
                      'History',
                      style: GoogleFonts.muli(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CallHistoryPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, size: 28),
                    title: Text(
                      'Log Out',
                      style: GoogleFonts.muli(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    onTap: () async {
                      changeAvailabilty(CommonConstants.userID, "no");
                      CommonConstants.socket.emit('user_login_logout');
                      await AuthClass().signOut();
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const LoginScreen()),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const LogInPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const MemberProfilePage(),
                    //   ),
                    // );
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  )),
            ],
            backgroundColor: CommonConstants.appcolor,
            title: const Text("Call with Astrologer"),
            titleTextStyle: GoogleFonts.muli(color: Colors.black, fontSize: 18),
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
                            ? Center(
                                child: Text(
                                "No members record found !!!",
                                style: GoogleFonts.muli(color: Colors.black),
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text('Exit app'),
          titleTextStyle: GoogleFonts.muli(),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Do you want to exit?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.muli(),
                ),
                SizedBox(height: CommonConstants.device_height/50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _build_btn_of_dialogue(
                      "Yes",
                      Colors.black,
                          () {
                        CommonConstants.socket.dispose();
                        SystemNavigator.pop();
                      },
                    ),
                    _build_btn_of_dialogue(
                      "No",
                      Colors.black,
                          () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                ),
                SizedBox(height: CommonConstants.device_height/50,),
              ],
            ),
          ),

        );
      },
    );
  }

  SizedBox _build_btn_of_dialogue(String btnname, Color color, Function ontap) {
    return SizedBox(
      height: CommonConstants.device_height /25,
      width: CommonConstants.device_width /6,
      child: ElevatedButton(
          child: Text(btnname,
              style:
                  GoogleFonts.muli(fontSize: CommonConstants.device_height/60, fontWeight: FontWeight.w300)),
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
}
