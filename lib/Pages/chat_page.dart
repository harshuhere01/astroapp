import 'package:astro/Pages/add_money_to_wallet.dart';
import 'package:astro/Widgets/user_listtile_design.dart';
import 'package:flutter/cupertino.dart';
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
      // user must tap button!
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

  void showUserDetailsDialogue(
    context,
    String photourl,
    String username,
    String usernamedetails,
    String email,
    String emailid,
    String number,
    String contactnumber,
    String location,
    String locationdetails,
    String gender,
    String gendertype,
    String lusername,
    String lusernamedetails,
    String lpsd,
    String lpsddetail,
  ) {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text(
            "User detail",
          ),
        ),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
        content: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          height: 350,
          // width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(photourl),
                    backgroundColor: Colors.transparent,
                  ),
                  const Divider(
                    height: 5,
                    color: Colors.black,
                  ),
                  build_user_details(username, usernamedetails),
                  build_user_details(email, emailid),
                  build_user_details(number, contactnumber),
                  build_user_details(location, locationdetails),
                  build_user_details(gender, gendertype),
                  build_user_details(lusername, lusernamedetails),
                  build_user_details(lpsd, lpsddetail),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row build_user_details(String fieldname, String fielddetails) {
    return Row(
      children: [
        Text(
          fieldname,
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        ),
        Flexible(
          child: Text(
            fielddetails,
            style: const TextStyle(
                // overflow: TextOverflow.visible,
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
