import 'dart:convert';
import 'dart:io';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Firebase%20Services/firebase_auth_service.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool gbtnprogress = false;
  List<dynamic>? userList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.yellow[600],
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Login to continue",
                        style: TextStyle(
                            color: Color(0xFF616161),
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              // height: MediaQuery.of(context).size.height/0.,
              // alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(5, 5),
                    ),
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                gbtnprogress = true;
                              });
                              try {
                                final result =
                                    await InternetAddress.lookup('example.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  print('connected');

                                  UserCredential? userCredential =
                                      await AuthClass()
                                          .googleSignin(context)
                                          .onError((error, stackTrace) {
                                    setState(() {
                                      gbtnprogress = false;
                                    });
                                    return null;
                                  });
                                  await registerUser(userCredential)
                                      .whenComplete(() {
                                    updateFCMToken();
                                  });
                                }
                              } on SocketException catch (_) {
                                setState(() {
                                  gbtnprogress = false;
                                });
                                Fluttertoast.showToast(
                                    msg:
                                        "There is no internet connection , please check your internet.");
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 215,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                border: Border.all(
                                    color: Colors.black87.withOpacity(0.1)),
                              ),
                              padding: const EdgeInsets.only(right: 7),
                              child: gbtnprogress
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ))
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'asset/google.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            'Continue with google',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> registerUser(userCredential) async {
    var response = await API().registerUser(
      "${userCredential.user!.displayName}",
      "${userCredential.user!.email}",
      "${userCredential.user!.photoURL}",
      CommonConstants.userFCMToken,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        gbtnprogress = false;
        CommonConstants.userID = res['data']['id'];
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('id', res['data']['id']);
      prefs.setString('name', '${res['data']['name']}');
      prefs.setString('email', '${res['data']['email']}');
      prefs.setString('photo', '${res['data']['photo']}');
      prefs.setString('age', '${res['data']['age']}');
      prefs.setString('sex', '${res['data']['sex']}');
      prefs.setString('mobile', '${res['data']['mobile']}');
      prefs.setString('available', '${res['data']['available']}');
      prefs.setString('isMember', '${res['data']['isMember']}');
      prefs.setString('isActive', '${res['data']['isActive']}');
      prefs.setString('fcm_token', '${res['data']['fcm_token']}');

      if (res['message'] == "") {
        Fluttertoast.showToast(msg: "Registered Successfully!!!");
      } else {
        Fluttertoast.showToast(msg: "Logged In Successfully!!!");
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const HomePage()),
          (route) => false);
    } else {
      Fluttertoast.showToast(
          msg: "Registration API :- ${response.statusCode} :- $res");
    }
  }

  Future<void> updateFCMToken() async {
    var response = await API().updateFCMToken();
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      // Fluttertoast.showToast(msg: res['message']);
    } else {
      Fluttertoast.showToast(
          msg: "updateFCMToken API :- ${response.statusCode} :- $res");
    }
  }
}
