import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Widgets/user_listtile_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key, this.itemlist}) : super(key: key);
  var itemlist;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: itemlist.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              child: UserListTile(
                userName: "${itemlist[index]['name']['first']}",
                imageURL: itemlist[index]['picture']['large'],
                designation: "Numerology, Face Reading",
                languages: "English, Hindi, Gujarati",
                experience: "Exp: 15 Years",
                charge: "₹ 60/min",
                totalnum: "12456",
                waitingtime: "wait time ~ 10m",
                onTapImage: () {},
                onTapOfTile: () {},
                callbtnclick: () {
                  _showCallClickDialog(context,
                      "Minimum balance of 5\nminutes (INR 90.0) is\nrequired to start call with\n${itemlist[index]['name']['first']}");
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCallClickDialog(context, String dialoguetext) async {
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
            _build_btn_of_dialogue("Cancel", const Color(0xFFFdd835), () {
              Navigator.pop(context);
            }),
            _build_btn_of_dialogue("Recharge", const Color(0xFF2D7D32),
                () async {
              Navigator.pop(context);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => AddMoneyPage()));
            }),
          ],
          actionsPadding: const EdgeInsets.all(15),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  SizedBox _build_btn_of_dialogue(String btnname, Color color, Function ontap) {
    return SizedBox(
      height: 40,
      width: 100,
      child: ElevatedButton(
          child: Text(btnname,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
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
