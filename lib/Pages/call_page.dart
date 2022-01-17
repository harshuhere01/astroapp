import 'package:astro/Widgets/user_listtile_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallPage extends StatelessWidget {
  CallPage({Key? key, this.itemlist}) : super(key: key);
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
        body: Container(
          child: ListView.builder(
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
                  callbtnclick: () {},
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMyDialog(context) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                // Navigator.pop(context, true);
                SystemNavigator.pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
                // return false;
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
