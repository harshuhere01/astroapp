import 'package:astro/Agora%20Functions/Video%20Call/screens/call/call_model.dart';
import 'package:astro/Agora%20Functions/Video%20Call/screens/home/home_model.dart';
import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Pages/payment_info.dart';
import 'package:astro/Pages/splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/src/darty.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initializeNotification();
  print("Handling a background message: ${message.messageId}");

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  Consumer(builder: (context, HomeNotifier homeNotifier, child) {
    AwesomeNotifications().actionStream.listen((receivedNotifiction) async {
      if (receivedNotifiction.buttonKeyPressed == "ACCEPT") {
        try {
          homeNotifier.onJoin(context, CommonConstants.joiningchannelName);
        } catch (e) {
          print("Error while connect to call :- $e");
        }
        print("Call Accepted from main page");
      } else if (receivedNotifiction.buttonKeyPressed == "CANCEL") {
        CommonConstants.socket.emit(
            'call_rejection', {"socketId": CommonConstants.callerSocketId});
        Fluttertoast.showToast(msg: "Call rejected");
        print("Call Rejected from main page");
      }
    });
    return Container();
  });

  if (notification != null && android != null) {
    await notify(message);
  }
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> initializeNotification() async {
  await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'basic_channel',
            channelDescription: 'Notification channel for basic tests',
            locked: false,
            importance: NotificationImportance.High,
            defaultRingtoneType: DefaultRingtoneType.Ringtone,
            playSound: true,
            enableVibration: true,
            channelShowBadge: true,
            vibrationPattern: highVibrationPattern,
            defaultColor: Colors.red,
            ledColor: Colors.blueAccent)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HomeNotifier()),
        ChangeNotifierProvider.value(value: CallNotifier()),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
