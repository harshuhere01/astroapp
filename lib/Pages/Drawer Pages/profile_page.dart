import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Model/get_single_user_api_model.dart';
import 'package:astro/Pages/Drawer%20Pages/edit_profile_page.dart';
import 'package:astro/Pages/Drawer%20Pages/member_profile_page.dart';
import 'package:astro/Pages/home_page.dart';
import 'package:astro/Widgets/simple_button.dart';
import 'package:astro/Widgets/text_filed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late GetSingleUserDetailsModel detailModel;

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
  final _languagesController = TextEditingController();
  final _experienceController = TextEditingController();

  bool isLoading = false;
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
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: CommonConstants.appcolor,
        title: const Text("Profile"),
        titleTextStyle: GoogleFonts.muli(color: Colors.black, fontSize: 18),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: CommonConstants.device_height / 55),
              padding: EdgeInsets.symmetric(
                  horizontal: CommonConstants.device_width / 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(CommonConstants.device_height / 100),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.whatsapp_rounded,
                      color: Colors.green,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Share',
                      style: GoogleFonts.muli(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              // add this line
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            "Edit Profile",
                            style: GoogleFonts.muli(color: Colors.black),
                          ),
                        ),
                        value: 'Edit Profile'),
                  ],
              onSelected: (index) async {
                switch (index) {
                  case 'Edit Profile':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => EditProfile(
                         detailModel: detailModel,
                          isMember: isMember,
                          isMemberRequested: isMemberRequested,
                        ),
                      ),
                    ).then((value) => getSingelUser());
                    break;
                }
              })
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please wait!!!",
                    style: GoogleFonts.muli(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                ],
              ),
            )
          : isMember
              ? MemberProfilePage(
                  detailModel: detailModel,
                  // chatMins: chatMins!,
                  // callMins: callMins!,
                  // aboutme: aboutme!,
                  // callRate: callRate!,
                  // designation: 'Astrologer',
                  // experience: experience!,
                  // imageURL: imageURL!,
                  // languages: languages!,
                  // userName: userName!,
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: CommonConstants.device_width / 50,
                          vertical: CommonConstants.device_height / 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                elevation: 3,
                                color: isMemberRequested || isMember
                                    ? CommonConstants.appcolor
                                    : null,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        CommonConstants.device_width / 20),
                                    side: BorderSide(color: Colors.black54)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          CommonConstants.device_height / 30,
                                      horizontal:
                                          CommonConstants.device_width / 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: isMemberRequested || isMember
                                              ? CommonConstants.appcolor
                                              : null,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipOval(
                                          child: FadeInImage(
                                            fit: BoxFit.cover,
                                            width:
                                                CommonConstants.device_height /
                                                    8,
                                            height:
                                                CommonConstants.device_height /
                                                    8,
                                            placeholder: const AssetImage(
                                                "asset/placeholder.png"),
                                            image: NetworkImage(
                                                detailModel.data!.photo ?? ''),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: isMemberRequested || isMember
                                            ? isMemberRequested && !isMember
                                                ? Center(
                                                    child: Text(
                                                        "Become member\nrequest pending !",
                                                        style: GoogleFonts.muli(
                                                            fontSize:
                                                                CommonConstants
                                                                        .device_width /
                                                                    20)),
                                                  )
                                                : Center(
                                                    child: Text(
                                                        "You're a member !",
                                                        style: GoogleFonts.muli(
                                                            fontSize:
                                                                CommonConstants
                                                                        .device_width /
                                                                    18)),
                                                  )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Become a Member ?",
                                                    style: GoogleFonts.muli(
                                                        color: Colors.black,
                                                        fontSize: CommonConstants
                                                                .device_width /
                                                            20,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  SizedBox(
                                                    height: CommonConstants
                                                            .device_height /
                                                        50,
                                                  ),
                                                  FlutterSwitch(
                                                    width: CommonConstants
                                                            .device_width *
                                                        0.2,
                                                    height: CommonConstants
                                                            .device_height *
                                                        0.04,
                                                    valueFontSize: 10.0,
                                                    toggleSize: 25.0,
                                                    value: togglebtn,
                                                    borderRadius: 20.0,
                                                    padding: 2.0,
                                                    showOnOff: true,
                                                    activeText: "Cancel",
                                                    activeTextColor:
                                                        Colors.black,
                                                    inactiveTextColor:
                                                        Colors.black,
                                                    activeColor:
                                                        const Color(0XFFFDD835),
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
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Card(
                              //   elevation: 3,
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(15),
                              //   ),
                              //   // child: Container(
                              //   //   height: CommonConstants.device_height * 0.075,
                              //   //   width: CommonConstants.device_width * 0.8,
                              //   //   padding: const EdgeInsets.all(10),
                              //   //   decoration: BoxDecoration(
                              //       color: isMemberRequested || isMember
                              //           ? CommonConstants.appcolor
                              //           : null,
                              //   //     border: Border.all(
                              //   //       color: Colors.black,
                              //   //       width: 1,
                              //   //     ),
                              //   //     borderRadius:
                              //   //         const BorderRadius.all(Radius.circular(15)),
                              //   //   ),
                              //   //   child:
                              //   //   isMemberRequested || isMember
                              //   //       ? isMemberRequested && !isMember
                              //   //           ?  Center(
                              //   //               child: Text(
                              //   //                   "Become member request pending !",style: GoogleFonts.muli(fontSize: CommonConstants.device_width/25),),
                              //   //             )
                              //   //           :  Center(
                              //   //               child: Text("You're a member !",style:GoogleFonts.muli(fontSize: CommonConstants.device_width/18)),
                              //   //             )
                              //   //       :
                              //   //   Column(
                              //   //           mainAxisAlignment:
                              //   //               MainAxisAlignment.spaceEvenly,
                              //   //           children: [
                              //   //              Text(
                              //   //               "Become a Member ?",
                              //   //               style: GoogleFonts.muli(
                              //   //                   color: Colors.black,
                              //   //                   fontSize: CommonConstants.device_width/20,
                              //   //                   fontWeight: FontWeight.w400),
                              //   //             ),
                              //   //             FlutterSwitch(
                              //   //               width:
                              //   //                   CommonConstants.device_width * 0.2,
                              //   //               height: CommonConstants.device_height *
                              //   //                   0.04,
                              //   //               valueFontSize: 10.0,
                              //   //               toggleSize: 25.0,
                              //   //               value: togglebtn,
                              //   //               borderRadius: 20.0,
                              //   //               padding: 2.0,
                              //   //               showOnOff: true,
                              //   //               activeText: "Cancel",
                              //   //               activeTextColor: Colors.black,
                              //   //               inactiveTextColor: Colors.black,
                              //   //               activeColor: const Color(0XFFFDD835),
                              //   //               inactiveText: "Request",
                              //   //               onToggle: (val) {
                              //   //                 if (!isMember) {
                              //   //                   setState(() {
                              //   //                     togglebtn = val;
                              //   //                     readOnly = val;
                              //   //                   });
                              //   //                 }
                              //   //               },
                              //   //             ),
                              //   //           ],
                              //   //         ),
                              //   // ),
                              // ),
                              //
                              // ///
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(
                                      minlines: 1,
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
                                      minlines: 1,
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
                                      minlines: 1,
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
                                      minlines: 1,
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
                                      minlines: 1,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomTextField(
                                            minlines: 1,
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
                                            minlines: 1,
                                            validators: (value) {
                                              if (value!.isEmpty) {
                                                return "*please enter social media links";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardTYPE: TextInputType.text,
                                            controller:
                                                _socialmediaLinkController,
                                            prefixIcon: Icons.abc,
                                            hint: "Social media links",
                                            readOnly: false,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CustomTextField(
                                            minlines: 1,
                                            validators: (value) {
                                              if (value!.isEmpty) {
                                                return "*please enter known languages";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardTYPE: TextInputType.text,
                                            controller: _languagesController,
                                            prefixIcon: Icons.abc,
                                            hint: "Languages",
                                            readOnly: false,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CustomTextField(
                                            minlines: 1,
                                            validators: (value) {
                                              if (value!.isEmpty) {
                                                return "*please enter experience";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardTYPE: TextInputType.text,
                                            controller: _experienceController,
                                            prefixIcon: Icons.abc,
                                            hint:
                                                "Experience(i.e 10 Years , 15 Years)",
                                            readOnly: false,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CustomTextField(
                                            minlines: 4,
                                            validators: (value) {
                                              if (value!.isEmpty) {
                                                return "*please enter achievements detail";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardTYPE: TextInputType.text,
                                            controller: _achievementsController,
                                            prefixIcon:
                                                Icons.emoji_events_outlined,
                                            hint: "Achievements",
                                            readOnly: false,
                                            ontapofsuffixicon: () {},
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CustomTextField(
                                            minlines: 4,
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
                              if (!isMemberRequested &&
                                  !isMember &&
                                  togglebtn) {
                                if (_memberformKey.currentState!.validate()) {
                                  await createMember(
                                    CommonConstants.userID,
                                    double.parse(_callRateController.text),
                                    _socialmediaLinkController.text,
                                    _aboutmeController.text,
                                    _achievementsController.text,
                                    "no",
                                    _languagesController.text,
                                    _experienceController.text,
                                  );
                                  Navigator.pop(context);
                                }
                              } else {
                                if (isMember) {
                                  if (_formKey.currentState!.validate() &&
                                      _memberformKey.currentState!.validate()) {
                                    await updateUSER(
                                        _nameController.text,
                                        _ageController.text,
                                        _genderController.text,
                                        _mobilenumberController.text,
                                        "yes",
                                        _callRateController.text,
                                        _achievementsController.text,
                                        _socialmediaLinkController.text,
                                        _aboutmeController.text,
                                        _languagesController.text,
                                        _experienceController.text);
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    await updateUSER(
                                        _nameController.text,
                                        _ageController.text,
                                        _genderController.text,
                                        _mobilenumberController.text,
                                        "yes",
                                        "",
                                        "",
                                        "",
                                        "",
                                        '',
                                        '');
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
    detailModel = await API().getSingelUser(CommonConstants.userID);

    if (detailModel.message == "") {
      setState(() {
        // callRate = detailModel.data!.callRate ?? '0';
        // callMins = detailModel.data!.totalCallMinute ?? '0';
        // chatMins = detailModel.data!.totalChatMinute ?? '0';
        // imageURL = detailModel.data!.photo ?? '';
        // userName = detailModel.data!.name ??'Name null';
        // languages = detailModel.data!.languages ?? 'languages null';
        // experience = detailModel.data!.experience ?? 'Experience null';
        // designation = 'Astrologer';
        // aboutme = detailModel.data!.aboutMe ?? 'About me';
        togglebtn = detailModel.data!.isMemberRequested ?? false;
        isMemberRequested = detailModel.data!.isMemberRequested ?? false;
        isMember = detailModel.data!.isMember ?? false;
        // imageURL = detailModel.data!.photo ?? '';
        _nameController.text = detailModel.data!.name ?? 'Name null';
        _emailController.text = detailModel.data!.email ?? '';
        _ageController.text = detailModel.data!.age ?? '';
        _genderController.text = detailModel.data!.sex ?? '';
        _mobilenumberController.text = detailModel.data!.mobile ?? '';
        _callRateController.text = detailModel.data!.callRate ?? '';
        _socialmediaLinkController.text =
            detailModel.data!.socialMediaLink ?? '';
        _languagesController.text = detailModel.data!.languages ?? '';
        _experienceController.text = detailModel.data!.experience ?? '';
        _achievementsController.text = detailModel.data!.achievements ?? '';
        _aboutmeController.text = detailModel.data!.aboutMe ?? '';
        CommonConstants.userIsMember = detailModel.data!.isMember ?? false;
        CommonConstants.userCallCharge =
            double.parse(detailModel.data!.callRate ?? '0.00');
        isLoading = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isMember', detailModel.data!.isMember ?? false);
      prefs.setDouble(
          'userCallCharge', double.parse(detailModel.data!.callRate ?? '0.00'));
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error :- ${detailModel.message}");
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
    String languages,
    String experience,
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
      languages,
      experience,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      Fluttertoast.showToast(msg: "Successfully updated!");
      if (isMember) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setDouble(
            'userCallCharge', double.parse(_callRateController.text));
        setState(() {
          CommonConstants.userCallCharge =
              double.parse(_callRateController.text);
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
    String languages,
    String experience,
  ) async {
    var response = await API().createMember(userId, callRate, socialMediaLink,
        aboutMe, achievements, status, languages, experience);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      Fluttertoast.showToast(msg: "Successfully requested!!!");
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setDouble('memberCallCharge',
      //     double.parse(_callRateController.text));
    } else {
      Fluttertoast.showToast(
          msg: "Fetchuser API error :- ${response.statusCode.toString()}");
    }
  }
}
