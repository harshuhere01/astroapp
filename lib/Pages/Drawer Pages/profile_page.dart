import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:astro/Widgets/simple_button.dart';
import 'package:astro/Widgets/text_filed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _memberformKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _mobilenumberController = TextEditingController();

  /// member controllers
  final _callRateController = TextEditingController();
  final _socialmediaLinkController = TextEditingController();
  final _achievementsController = TextEditingController();
  final _aboutmeController = TextEditingController();

  bool isLoading = false;
  String? photo;
  bool togglebtn = false;
  bool isMemberRequested = false;
  bool isMember = false;
  bool readOnly = false;

  navigateToHomePage(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => const HomePage()),
        (route) => false);
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getSingelUser().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.yellow[600],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(
                CommonConstants.device_width * 0.04,
                CommonConstants.device_height * 0.02,
                CommonConstants.device_width * 0.04,
                CommonConstants.device_width * 0.04),
            padding: const EdgeInsets.all(25),
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please wait!!!",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  width: CommonConstants.device_height / 5.5,
                                  height: CommonConstants.device_height / 5.5,
                                  placeholder:
                                      const AssetImage("asset/placeholder.png"),
                                  image: NetworkImage("$photo"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: CommonConstants.device_height * 0.075,
                            width: CommonConstants.device_width * 0.8,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMemberRequested || isMember
                                  ? Colors.yellow[600]
                                  : null,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: isMemberRequested || isMember
                                ? isMemberRequested && !isMember
                                    ? const Center(
                                        child: Text(
                                            "Become member request pending !"),
                                      )
                                    : const Center(
                                        child: Text("You're member !"),
                                      )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "Become a Member ?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      FlutterSwitch(
                                        width:
                                            CommonConstants.device_width * 0.2,
                                        height: CommonConstants.device_height *
                                            0.04,
                                        valueFontSize: 10.0,
                                        toggleSize: 25.0,
                                        value: togglebtn,
                                        borderRadius: 20.0,
                                        padding: 2.0,
                                        showOnOff: true,
                                        activeText: "Cancel",
                                        activeTextColor: Colors.black,
                                        inactiveTextColor: Colors.black,
                                        activeColor: const Color(0XFFFDD835),
                                        inactiveText: "Request",
                                        onToggle: (val) {
                                          if (!isMember) {
                                            setState(() {
                                              togglebtn = val;
                                              readOnly = val;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                          ),

                          ///
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  controller: _nameController,
                                  prefixIcon: Icons.person,
                                  hint: "Name",
                                  validators: (value) {
                                    if (value!.isEmpty) {
                                      return "*please enter name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardTYPE: TextInputType.name,
                                  readOnly: readOnly,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  maxlength: 100,
                                  validators: (value) {
                                    if (value == null || value == "") {
                                      return '*please enter email address';
                                    } else {
                                      return EmailValidator.validate(value)
                                          ? null
                                          : "*Please enter a valid email";
                                    }
                                  },
                                  keyboardTYPE: TextInputType.emailAddress,
                                  controller: _emailController,
                                  prefixIcon: Icons.email,
                                  hint: "Email",
                                  readOnly: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  validators: (value) {
                                    return null;
                                  },
                                  keyboardTYPE: TextInputType.number,
                                  controller: _ageController,
                                  prefixIcon: Icons.calendar_month,
                                  hint: "Age",
                                  readOnly: readOnly,
                                  ontapofsuffixicon: () {},
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  validators: (value) {
                                    return null;
                                  },
                                  keyboardTYPE: TextInputType.text,
                                  controller: _genderController,
                                  prefixIcon: Icons.transgender,
                                  hint: "Gender",
                                  readOnly: readOnly,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  validators: (value) {
                                    return null;
                                  },
                                  keyboardTYPE: TextInputType.number,
                                  controller: _mobilenumberController,
                                  prefixIcon: Icons.phone_android,
                                  hint: "Mobile number",
                                  readOnly: readOnly,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          togglebtn && !isMemberRequested || isMember
                              ? Form(
                                  key: _memberformKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextField(
                                        controller: _callRateController,
                                        prefixIcon: Icons.call,
                                        hint: "Call rate",
                                        validators: (value) {
                                          if (value!.isEmpty) {
                                            return "*please enter rate";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardTYPE: TextInputType.number,
                                        readOnly: false,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextField(
                                        validators: (value) {
                                          if (value!.isEmpty) {
                                            return "*please enter achievements detail";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardTYPE: TextInputType.text,
                                        controller: _achievementsController,
                                        prefixIcon: Icons.emoji_events_outlined,
                                        hint: "Achievements",
                                        readOnly: false,
                                        ontapofsuffixicon: () {},
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextField(
                                        validators: (value) {
                                          if (value!.isEmpty) {
                                            return "*please enter social media links";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardTYPE: TextInputType.text,
                                        controller: _socialmediaLinkController,
                                        prefixIcon: Icons.abc,
                                        hint: "Social media links",
                                        readOnly: false,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextField(
                                        validators: (value) {
                                          if (value!.isEmpty) {
                                            return "*please write something about you";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardTYPE: TextInputType.text,
                                        controller: _aboutmeController,
                                        prefixIcon:
                                            Icons.question_mark_outlined,
                                        hint: "About me",
                                        readOnly: false,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BtnWidget(
                        lable: togglebtn && !isMemberRequested
                            ? "Request Member!"
                            : "Save",
                        height: 45,
                        width: 200,
                        ontap: () async {
                          if (!isMemberRequested && !isMember && togglebtn) {
                            if (_memberformKey.currentState!.validate()) {
                              await createMember(
                                  CommonConstants.userID,
                                  double.parse(_callRateController.text),
                                  _socialmediaLinkController.text,
                                  _aboutmeController.text,
                                  _achievementsController.text,
                                  "no");
                              Navigator.pop(context);
                            }
                          } else {
                            if (isMember) {
                              if (_formKey.currentState!.validate() && _memberformKey.currentState!.validate()) {
                                await updateUSER(
                                    _nameController.text,
                                    _ageController.text,
                                    _genderController.text,
                                    _mobilenumberController.text,
                                    "yes",
                                    _callRateController.text,
                                    _achievementsController.text,
                                    _socialmediaLinkController.text,
                                    _aboutmeController.text);
                                Navigator.pop(context);
                              }
                            } else {
                              if(_formKey.currentState!.validate()) {
                                await updateUSER(
                                    _nameController.text,
                                    _ageController.text,
                                    _genderController.text,
                                    _mobilenumberController.text,
                                    "yes",
                                    "",
                                    "",
                                    "",
                                    "");
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> getSingelUser() async {
    var response = await API().getSingelUser(CommonConstants.userID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        isLoading = false;
        togglebtn = res['data']['isMemberRequested']??false;
        isMemberRequested = res['data']['isMemberRequested']??false;
        isMember = res['data']['isMember']??false;
        photo = res['data']['photo']??'';
        _nameController.text = res['data']['name']??'';
        _emailController.text = res['data']['email']??'';
        _ageController.text = res['data']['age']??'';
        _genderController.text = res['data']['sex']??'';
        _mobilenumberController.text = res['data']['mobile']??'';
        _callRateController.text = res['data']['call_rate']?? '';
        _achievementsController.text = res['data']['achievements']?? '';
        _socialmediaLinkController.text = res['data']['social_media_link']?? '';
        _aboutmeController.text = res['data']['about_me']?? '';
        CommonConstants.userIsMember = res['data']['isMember']??false;
        CommonConstants.userCallCharge =double.parse(res['data']['call_rate']??0.00) ;

      });
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error :- ${response.statusCode.toString()}");
    }
  }

  Future<void> updateUSER(
    String name,
    String age,
    String gender,
    String mobile,
    String available,
    String callRate,
    String achievements,
    String socialmediaLink,
    String aboutMe,
  ) async {
    var response = await API().updateUser(
      name,
      age,
      gender,
      mobile,
      available,
      callRate,
      achievements,
      socialmediaLink,
      aboutMe,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      Fluttertoast.showToast(msg: "Successfully updated!!!");
      if(isMember) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setDouble('memberCallCharge',
            double.parse(_callRateController.text));
        setState(() {
          CommonConstants.userCallCharge = double.parse(_callRateController.text);
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error :- ${response.statusCode.toString()}");
    }
  }

  Future<void> createMember(
    int userId,
    double callRate,
    String socialMediaLink,
    String aboutMe,
    String achievements,
    String status,
  ) async {
    var response = await API().createMember(
        userId, callRate, socialMediaLink, aboutMe, achievements, status);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      Fluttertoast.showToast(msg: "Successfully requested!!!");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('memberCallCharge',
          double.parse(_callRateController.text));
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error :- ${response.statusCode.toString()}");
    }
  }
}
