import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // loginUser();

    navigatetoDashBoard();
  }

  List<dynamic>? userList;

  final String apiUrl = "https://randomuser.me/api/?results=50";

  Future<void> fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    var data = json.decode(result.body)['results'];
    setState(() {
      userList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    CommonConstants.device_width= MediaQuery.of(context).size.width;
    CommonConstants.device_height= MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SpinKitSquareCircle(
            color: Colors.black,
            size: 100.00,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Welcome!!!",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w300, fontSize: 30),
          )
        ],
      ),
    );
  }

  void navigatetoDashBoard() async {
    await fetchUsers().whenComplete(() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (builder) => HomePage(
                    userList: userList,
                  )),
          (route) => false);
    });
  }

  // void loginUser() {}
}
