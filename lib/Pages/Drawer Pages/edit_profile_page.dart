import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Model/get_single_user_api_model.dart';
import 'package:astro/Widgets/simple_button.dart';
import 'package:astro/Widgets/text_filed.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  EditProfile({
    Key? key,
    required this.detailModel,
    required this.isMember,
    required this.isMemberRequested,
  }) : super(key: key);

  bool isMemberRequested = false;
  bool isMember = false;
  GetSingleUserDetailsModel detailModel;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    _nameController.text = widget.detailModel.data!.name??'';
    _ageController.text = widget.detailModel.data!.age??'';
    _genderController.text = widget.detailModel.data!.sex??'';
    _mobilenumberController.text = widget.detailModel.data!.mobile??'';
    _callRateController.text = widget.detailModel.data!.callRate??'';
    _socialmediaLinkController.text = widget.detailModel.data!.socialMediaLink??'';
    _achievementsController.text = widget.detailModel.data!.achievements??'';
    _aboutmeController.text = widget.detailModel.data!.aboutMe??'';
    _emailController.text = widget.detailModel.data!.email??'';
    _languagesController.text = widget.detailModel.data!.languages??'';
    _experienceController.text = widget.detailModel.data!.experience??'';
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
      ),
      body: SafeArea(
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
                      color: widget.isMemberRequested || widget.isMember
                          ? CommonConstants.appcolor
                          : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              CommonConstants.device_width / 20),
                          side: const BorderSide(color: Colors.black54)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: CommonConstants.device_height / 30,
                            horizontal: CommonConstants.device_width / 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    widget.isMemberRequested || widget.isMember
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
                                  width: CommonConstants.device_height / 8,
                                  height: CommonConstants.device_height / 8,
                                  placeholder:
                                      const AssetImage("asset/placeholder.png"),
                                  image: NetworkImage(widget.detailModel.data!.photo ?? ''),
                                ),
                              ),
                            ),
                            Container(
                                child: Center(
                              child: Text("You're a member !",
                                  style: GoogleFonts.muli(
                                      fontSize:
                                          CommonConstants.device_width / 18)),
                            )),
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
                            readOnly: false,
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
                              if (value == null || value == "") {
                                return '*please enter age';
                              } else {
                                return null;
                              }
                            },
                            keyboardTYPE: TextInputType.number,
                            controller: _ageController,
                            prefixIcon: Icons.calendar_month,
                            hint: "Age",
                            readOnly: false,
                            ontapofsuffixicon: () {},
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            minlines: 1,
                            validators: (value) {
                              if (value == null || value == "") {
                                return '*please enter gender';
                              } else {
                                return null;
                              }
                            },
                            keyboardTYPE: TextInputType.text,
                            controller: _genderController,
                            prefixIcon: Icons.transgender,
                            hint: "Gender",
                            readOnly: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            minlines: 1,
                            validators: (value) {
                              if (value == null || value == "") {
                                return '*please enter mobile number';
                              } else {
                                return null;
                              }
                            },
                            keyboardTYPE: TextInputType.number,
                            controller: _mobilenumberController,
                            prefixIcon: Icons.phone_android,
                            hint: "Mobile number",
                            readOnly: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                            controller: _socialmediaLinkController,
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
                            hint: "Experience(i.e 10 Years , 15 Years)",
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
                            keyboardTYPE: TextInputType.multiline,
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
                            minlines: 4,
                            validators: (value) {
                              if (value!.isEmpty) {
                                return "*please write something about you";
                              } else {
                                return null;
                              }
                            },
                            keyboardTYPE: TextInputType.multiline,
                            controller: _aboutmeController,
                            prefixIcon: Icons.question_mark_outlined,
                            hint: "About me",
                            readOnly: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                BtnWidget(
                    lable: "Save",
                    height: 45,
                    width: 200,
                    ontap: () async {
                      if (_formKey.currentState!.validate()) {
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
                    }),
              ],
            ),
          ),
        ),
      ),
    );
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
      Fluttertoast.showToast(msg: "Successfully updated!!!");
      if (widget.isMember) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setDouble(
            'userCallCharge', double.parse(_callRateController.text));
        setState(() {
          CommonConstants.userCallCharge =
              double.parse(_callRateController.text);
        });
        CommonConstants.socket.emit('user_login_logout');
      }
    } else {
      Fluttertoast.showToast(
          msg: "Update User error :- ${response.statusCode.toString()}");
    }
  }
}
