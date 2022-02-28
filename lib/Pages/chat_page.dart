
import 'package:astro/Constant/CommonConstant.dart';

import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key,}) : super(key: key);


  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("No data found !!!",style: TextStyle(color: Colors.black),)));
  }
}

// for send notification
// static Future<bool> sendFcmMessage(
//     String title, String message, String fcmToken) async {
//   try {
//     var header = {
//       "Content-Type": "application/json",
//       "Authorization": "key=AAAApOGu0ok:APA91bFS07zT3qrfNpSpFjIVfJ_QzKc0ujfd3FTxLuLONesfgYBBV0Yh9u5Wm2jWWSsVe4fUF4tu1caGIbkzc1LvPqJOHh-Y6yXdu2HrQxE9Q8OtqXO3MTSZZfW4Lb1cYAi6-q0M8jN6",
//     };
//     var request = {
//       "notification": {
//         "title": title,
//         "body": message,
//         "data": Agora.APP_ID,
//         "sound": "default",
//         "color": "#990000",
//
//       },
//       "priority": "high",
//       "to": fcmToken,
//     };
//
//     var client = new Client();
//     var response = await client.post(
//         Uri.parse(APIConstants.FirebaseNotificationAPI),
//         headers: header,
//         body: json.encode(request));
//     return true;
//   } catch (e, s) {
//     print(e);
//     print(s);
//     return false;
//   }
// }
