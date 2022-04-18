import 'dart:convert';
import 'dart:io';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Firebase%20Services/firebase_auth_service.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool gbtnprogress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: CommonConstants.device_height / 15,
                      ),
                      SizedBox(
                          height: CommonConstants.device_height / 5,
                          child: Image.asset('asset/app_logo.png')),
                      SizedBox(
                        height: CommonConstants.device_height / 50,
                      ),
                      Text(
                        'FOLO',
                        style: GoogleFonts.muli(
                            fontSize: CommonConstants.device_height / 35),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: CommonConstants.appcolor,
                ),
              ),
            ],
          ),
          Center(
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: CommonConstants.device_width / 10,
                      vertical: CommonConstants.device_height / 120),
                  margin: EdgeInsets.only(
                      bottom: CommonConstants.device_height / 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                        Radius.circular(CommonConstants.device_width / 10)),
                  ),
                  child: Text(
                    'First Chat with Astrologer is FREE!',
                    style: GoogleFonts.muli(
                        color: Colors.black,
                        fontSize: CommonConstants.device_height / 50,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: InkWell(
              onTap: () async {
                setState(() {
                  gbtnprogress = true;
                });
                try {
                  final result = await InternetAddress.lookup('example.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    print('connected');
                    try {
                      UserCredential? userCredential = await AuthClass()
                          .googleSignin(context)
                          .onError((error, stackTrace) {
                        setState(() {
                          gbtnprogress = false;
                        });
                        return null;
                      });
                      await registerUser(userCredential).whenComplete(() {
                        updateFCMToken();
                      });
                    } catch (e) {
                      setState(() {
                        gbtnprogress = false;
                      });
                      print(e);
                    }
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
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: Colors.black87.withOpacity(0.1)),
                ),
                padding: const EdgeInsets.only(right: 7),
                child: gbtnprogress
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.black,
                      ))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/google.png',
                            height: 30,
                            width: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'Continue with google',
                              style: GoogleFonts.muli(
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: CommonConstants.device_height/9,
              padding: EdgeInsets.symmetric(vertical: CommonConstants.device_height/80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  _buildRow('100%','Privacy'),
                  const VerticalDivider(
                    width: 1,
                    color: Colors.black,
                  ),
                  _buildRow('3000+','Top astrologers of India'),
                  const VerticalDivider(
                    width: 1,
                    color: Colors.black,
                  ),
                  _buildRow('2Cr+','Happy customers'),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildRow(String mainText,String subText){
    return Expanded(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(mainText,textAlign: TextAlign.center,style: GoogleFonts.muli(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: CommonConstants.device_height/40),),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: CommonConstants.device_width/35),
            child: Text(subText,textAlign: TextAlign.center,style: GoogleFonts.muli(color: Colors.black87,fontWeight: FontWeight.w300,fontSize: CommonConstants.device_height/60),),
          ),
        ],
      ),
    );
  }

  Future<void> registerUser(userCredential) async {
    var response = await API().registerUser(
      "${userCredential.user!.displayName}",
      "${userCredential.user!.email}",
      "${userCredential.user!.photoURL}",
      CommonConstants.userFCMToken,
      "",
      "",
      "",
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('id', res['data']['id']);
      prefs.setString('name', '${res['data']['name'] ?? ''}');
      prefs.setString('email', '${res['data']['email'] ?? ''}');
      prefs.setString('photo', '${res['data']['photo'] ?? ''}');
      prefs.setString('age', '${res['data']['age'] ?? ''}');
      prefs.setString('sex', '${res['data']['sex'] ?? ''}');
      prefs.setString('mobile', '${res['data']['mobile'] ?? ''}');
      prefs.setString('available', '${res['data']['available'] ?? ''}');
      prefs.setBool('isMember', res['data']['isMember'] ?? false);
      prefs.setString('isActive', '${res['data']['isActive'] ?? ''}');
      prefs.setString('fcm_token', '${res['data']['fcm_token'] ?? ''}');
      prefs.setDouble(
          'userCallCharge', double.parse(res['data']['call_rate'] ?? "0"));

      setState(() {
        CommonConstants.userID = res['data']['id'] ?? 0;
        CommonConstants.callerIdforStatusChange = res['data']['id'] ?? 0;
        CommonConstants.userName = res['data']['name'] ?? '';
        CommonConstants.userEmail = res['data']['email'] ?? '';
        CommonConstants.userAge = res['data']['age'] ?? '';
        CommonConstants.userGender = res['data']['sex'] ?? '';
        CommonConstants.userMobilenumber = res['data']['mobile'] ?? '';
        CommonConstants.userPhoto = res['data']['photo'] ?? '';
        CommonConstants.userCallCharge =
            double.parse(res['data']['call_rate'] ?? "0");
        CommonConstants.userIsMember = res['data']['isMember'] ?? false;
      });

      if (res['message'] == "") {
        Fluttertoast.showToast(msg: "Registered Successfully!!!");
      } else {
        Fluttertoast.showToast(msg: "Logged In Successfully!!!");
        await changeAvailabilty(res['data']['id'] ?? 0, "yes");
        CommonConstants.socket.emit('user_login_logout');
      }
      setState(() {
        gbtnprogress = false;
        // CommonConstants.userID = res['data']['id']??0;
      });
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

  Future<void> changeAvailabilty(int userID, String status) async {
    var response = await API().changeAvailabilty(userID, status);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      // Fluttertoast.showToast(msg: res['message']);
    } else {
      Fluttertoast.showToast(
          msg: "changeAvailabilty API :- ${response.statusCode} :- $res");
    }
  }
}
