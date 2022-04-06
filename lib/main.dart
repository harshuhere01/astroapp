import 'package:astro/Agora%20Functions/Video%20Call/screens/call/call_model.dart';
import 'package:astro/Agora%20Functions/Video%20Call/screens/home/home_model.dart';
import 'package:astro/Pages/splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeNotification();
  runApp(const MyApp());
}

initializeNotification() async {
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
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}