import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Pages/call_page.dart';
import 'package:astro/Pages/chat_page.dart';
import 'package:astro/Widgets/tab_button.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socket_io_client/src/darty.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.userList}) : super(key: key);

  List<dynamic>? userList;

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
  String? walletBalance;
  String buttonName = "Check wallet balance";
  String? astroStatus;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;

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
    walletBalance = "";
    socketConnectToServer();
    handleNotificationEvents();
    // initMessaging();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  handleNotificationEvents() {
    AwesomeNotifications().actionStream.listen((receivedNotifiction) {
      if (receivedNotifiction.buttonKeyPressed == "ACCEPT") {
        print("Call Accept");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => AddMoneyPage(
                      balance: "5000",
                    )));
      } else if (receivedNotifiction.buttonKeyPressed == "CANCEL") {
        print("Call Reject");
      }
    });
  }

  void initMessaging() {
    var androiInit =
        const AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
    var iosInit = const IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Fluttertoast.showToast(msg: 'A new onMessageOpenedApp event was published! :- ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print('FirebaseMessaging.onMessage.listen' + message.data.toString());

      if (notification != null && android != null) {
        // fltNotification.show(notification.hashCode, notification.title,
        //     notification.body, generalNotificationDetails);
        // Future.delayed(const Duration(seconds: 5),(){
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (builder) => AddMoneyPage(
        //               balance: "5000",
        //             )));

        // });
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp");
    });
  }

  socketConnectToServer() {
    try {
      print("socket connection process started");
      CommonConstants.socket.connect();
      CommonConstants.socket.onConnect((data) {
        print("========== on socket connect");
        setState(() {
          CommonConstants.socketID = "${CommonConstants.socket.id}";
        });
        print("Socket Connection :-:" +
            CommonConstants.socket.connected.toString());
      });

      // CommonConstants.socket.emit(
      //     'socket_connected_frontend', {"id": CommonConstants.socket.id});
      CommonConstants.socket.on('call_status', (data) {
        print("========== on call_status");
        Fluttertoast.showToast(msg: "Call status = ${data['status']}");
        setState(() {
          astroStatus = data['status'];
        });
      });
      CommonConstants.socket.on("socket_connected_backend", (data) {
        print(
            "========== on socket_connected_backend  :- $data ");
      });
      CommonConstants.socket.on('no_data', (data) {
        print("========== on no_data");
        Fluttertoast.showToast(msg: data.toString());
      });
      CommonConstants.socket.on('event', (data) {
        print("========== on event");
        Fluttertoast.showToast(msg: data.toString());
      });
    } catch (e) {
      print("socket_error:" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tepped Search")));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tepped Settings")));
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
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: 200,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.black87.withOpacity(0.1)),
                ),
                padding: const EdgeInsets.all(2),
                child: TextButton(
                  onPressed: () async {
                    // CommonConstants.socket.emit(
                    //     'socket_connected_frontend', {"id": CommonConstants.socket.id});
                    await getWalletBalance();
                  },
                  child: Text(
                    buttonName,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              walletBalance == null || walletBalance == ""
                  ? Container()
                  : Text(
                      "Your wallet Balance is : ₹ $walletBalance",
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),
            ],
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: TabButton(
                      selectedPage: _selectedPage,
                      pageNumber: 0,
                      text: "Chat",
                      onPressed: () {
                        _changePage(0);
                      }),
                ),
                Expanded(
                  flex: 2,
                  child: TabButton(
                      selectedPage: _selectedPage,
                      pageNumber: 1,
                      text: "Call",
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
                  buttonName = "Check wallet balance";
                  walletBalance = "";
                });
              },
              controller: _pageController,
              children: [
                widget.userList!.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : ChatPage(
                        itemlist: widget.userList,
                        astroStatus: astroStatus,
                      ),
                widget.userList!.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : CallPage(
                        itemlist: widget.userList,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getWalletBalance() async {
    var response = await API().getWalletBalance();
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        walletBalance = res["wallet_amount"];
        buttonName = "Check balance again";
      });
      Fluttertoast.showToast(
          msg: "Wallet Amount is :- ${res["wallet_amount"]}");
    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }
}
