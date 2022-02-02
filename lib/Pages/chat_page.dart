import 'dart:convert';

import 'package:astro/Agora%20Functions/Video%20Call/screens/home/home_model.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Constant/api_constant.dart';
import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Widgets/user_listtile_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, this.itemlist}) : super(key: key);
  var itemlist;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog(context);
        return false;
      },
      child: Consumer(
        builder: (context, HomeNotifier homeNotifier, child)
        {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: widget.itemlist.length,
            itemBuilder: (BuildContext context, int index) {
              int age = widget.itemlist[index]['dob']['age'];
              return Card(
                elevation: 5,
                child: UserListTile(
                  userName: "${widget.itemlist[index]['name']['first']}",
                  imageURL: widget.itemlist[index]['picture']['large'],
                  designation: "Numerology, Face Reading",
                  languages: "English, Hindi, Gujarati",
                  experience: "Exp: 15 Years",
                  charge: "₹ 60/min",
                  totalnum: "12456",
                  age :widget.itemlist[index]['dob']['age'],
                  waitingstatus: age > 60 ? "" : age < 40 ? "wait time - 4m" : "",
                  btncolor:age > 60 ? MaterialStateProperty.all<Color>(
                      Colors.grey) :age < 40 ? MaterialStateProperty.all<Color>(
                      Colors.red) : MaterialStateProperty.all<Color>(
                      Colors.green),
                  btnbordercolor: age > 60 ?
                      Colors.grey :age < 40 ?
                      Colors.red :
                      Colors.green,
                  onTapImage: () {},
                  onTapOfTile: () {},
                  callbtnclick: () {
                      _showCallClickDialog(context,
                          "Minimum balance of 5\nminutes (INR 90.0) is\nrequired to start call with\n${widget.itemlist[index]['name']['first']}",homeNotifier);
                  },
                ),
              );
            },
          ),

        );
        },
      ),
    );
  }

  void _showCallClickDialog(context, String dialoguetext,homeNotifier) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(dialoguetext),
              ],
            ),
          ),
          contentTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          actions: <Widget>[
            _build_btn_of_dialogue("Cancel", Colors.black, () {
              Navigator.pop(context);
            }),
            _build_btn_of_dialogue("Recharge",  Colors.black,
                () async {
              Navigator.pop(context);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => AddMoneyPage()));
            }),
            _build_btn_of_dialogue("Video Call",  Colors.black, ()  {
               createTokenAPI(homeNotifier).whenComplete(() {
                 homeNotifier.onJoin(context,Agora.Channel_name);
               });
            }),
          ],
          actionsPadding: const EdgeInsets.all(15),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }




  Future<void> createTokenAPI(homeNotifier) async {

    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.CreateToken  );
    final headers = {'Content-Type': 'application/json',};
    Map<String, dynamic> body = {
      "channel_name":"myChannel",
      "uid":Agora.UUID,
      "role":"customer",
      "expire_time":null
    };
    String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      // encoding: encoding,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      Fluttertoast.showToast(msg: res.toString());
      await setAgoraVariables(res).whenComplete(() {
        Fluttertoast.showToast(msg: "variables set succssfully");
        // try{
        //   homeNotifier.onJoin(context,Agora.Channel_name);
        // }
        //     catch(e){
        //       Fluttertoast.showToast(msg: e.toString());
        //     }
      });

    }
    else{
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }

  Future<void> setAgoraVariables (res)async{
    setState(() {
      Agora.APP_ID = res["appId"];
      Agora.UUID = res['uid'];
      Agora.Channel_name = res['channel'];
      Agora.Token = res['token'];
    });
  }

  SizedBox _build_btn_of_dialogue(String btnname, Color color, Function ontap) {
    return SizedBox(
      height: 40,
      width: 80,
      child: ElevatedButton(
          child: Text(btnname,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w300)),
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


  void _showMyDialog(context) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: const Text('Exit app'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
