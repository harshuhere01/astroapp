import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/review_list.dart';
import 'package:astro/Model/get_single_user_api_model.dart';
import 'package:astro/Widgets/expandable_container.dart';
import 'package:astro/Widgets/member_profile_card.dart';
import 'package:astro/Widgets/rating_bar.dart';
import 'package:astro/Widgets/review_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MemberProfilePage extends StatefulWidget {
  MemberProfilePage({
    Key? key,
    required this.detailModel,
    // required this.callRate,
    // required this.userName,
    // required this.designation,
    // required this.experience,
    // required this.imageURL,
    // required this.aboutme,
    // required this.callMins,
    // required this.chatMins,
    // required this.languages,
  }) : super(key: key);
  // String callRate;
  // String imageURL;
  // String userName;
  // String languages;
  // String experience;
  // String designation;
  // String aboutme;
  // String callMins;
  // String chatMins;
  GetSingleUserDetailsModel detailModel;

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: CommonConstants.device_width / 200),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: CommonConstants.device_width / 30,
              vertical: CommonConstants.device_height / 100),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: CommonConstants.appcolor, spreadRadius: 1),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(CommonConstants.device_height / 50),
                topRight: Radius.circular(CommonConstants.device_height / 50)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Chat with ${widget.detailModel.data!.name??''}',
                    style: GoogleFonts.muli(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: CommonConstants.device_height / 55,
                    ),
                  ),
                  SizedBox(
                    width: CommonConstants.device_width / 50,
                  ),
                  Text(
                    "₹ ${widget.detailModel.data!.callRate??'0'}/min",
                    style: GoogleFonts.muli(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: CommonConstants.device_height / 60,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: CommonConstants.device_height / 100,
              ),
              Row(
                children: [
                  _buildButton(
                    'Chat',
                    Icons.question_answer_outlined,
                    () {},
                    Colors.green,
                    Colors.green,
                  ),
                  _buildButton(
                    'Call',
                    Icons.call,
                    () {},
                    Colors.grey[600],
                    Colors.grey[600],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: CommonConstants.device_width / 8,
                    top: CommonConstants.device_width / 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Not available',
                        style: GoogleFonts.muli(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: CommonConstants.device_height / 80,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: CommonConstants.device_height / 200,
            ),
            MemberProfileCard(
              callMins: widget.detailModel.data!.totalCallMinute??'0',
              chatMins: widget.detailModel.data!.totalChatMinute??'0',
              imageURL: widget.detailModel.data!.photo??'',
              userName: widget.detailModel.data!.name??'',
              charge: "₹ ${widget.detailModel.data!.callRate??'0'}/min",
              experience: widget.detailModel.data!.experience??'0',
              languages: widget.detailModel.data!.languages??'',
              designation: 'Astrologer',
              callbtnclick: () {},
              onTapImage: () {},
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                AboutMe(aboutMe: widget.detailModel.data!.aboutMe??''),
              ],
            ),
            _buildAvailabilityContainer(() {
              Fluttertoast.showToast(msg: 'Checked Availability');
            }),
            _buildRatingandReviews(),
            _buildReviewsList(),
          ],
        ),
      ),
    );
  }

  _buildButton(String text, IconData icon, Function onTap, Color? iconColor,
      Color? textColor) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: CommonConstants.device_height / 22,
          padding: EdgeInsets.symmetric(
              horizontal: CommonConstants.device_width / 30),
          margin: EdgeInsets.symmetric(
              horizontal: CommonConstants.device_width / 200),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(
                Radius.circular(CommonConstants.device_width / 10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: CommonConstants.device_width / 20,
              ),
              Text(
                text,
                style: GoogleFonts.muli(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: CommonConstants.device_height / 50),
              ),
              SizedBox(
                width: CommonConstants.device_width / 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildAvailabilityContainer(Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: CommonConstants.device_width / 20),
          height: CommonConstants.device_height / 16,
          width: CommonConstants.device_width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(CommonConstants.device_width / 100)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.event_available,
                size: CommonConstants.device_height / 25,
              ),
              Text(
                'Availability',
                style: GoogleFonts.muli(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: CommonConstants.device_height / 50),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: CommonConstants.device_height / 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildRatingandReviews() {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: CommonConstants.device_width / 25,
            vertical: CommonConstants.device_height / 50),
        decoration: const BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rating and reviews',
                  style: GoogleFonts.muli(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: CommonConstants.device_height / 45,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Fluttertoast.showToast(msg: 'Ratings & reviews');
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey,
                    size: CommonConstants.device_height / 35,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: CommonConstants.device_height / 50,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '4.93',
                        style: GoogleFonts.muli(
                            fontSize: CommonConstants.device_height / 23,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: CommonConstants.device_height / 150,
                      ),
                      StarRating(
                        alignStart: false,
                        color: Colors.grey[600],
                        rating: 5,
                        starCount: 5,
                      ),
                      SizedBox(
                        height: CommonConstants.device_height / 300,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 15,
                            color: Colors.grey[600],
                          ),
                          Text(
                            "9696 total",
                            style: GoogleFonts.openSans(
                                color: Colors.grey[600],
                                fontSize: CommonConstants.device_height / 70,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rating("5", Colors.green, 4.5),
                      rating("4", Colors.blue, 3),
                      rating("3", Colors.green, 2),
                      rating("2", Colors.red[200], 1.2),
                      rating("1", Colors.red, 0.4),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  width(double value) {
    return SizedBox(
      width: value,
    );
  }

  text(
      {required String value,
      required double textSize,
      required Color textColor,
      required FontWeight fontWeight,
      FontStyle fontStyle = FontStyle.normal}) {
    return Container(
        child: Text(
      value,
      style: GoogleFonts.muli(
          fontSize: textSize,
          color: textColor,
          fontWeight: fontWeight,
          fontStyle: fontStyle),
    ));
  }

  rating(String value, Color? color, double percentage) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: CommonConstants.device_height / 200),
      child: LinearPercentIndicator(
        leading: text(
            value: value,
            textSize: CommonConstants.device_height / 50,
            textColor: Colors.black,
            fontWeight: FontWeight.w500),
        animation: true,
        lineHeight: CommonConstants.device_height / 50,
        animationDuration: 2000,
        percent: percentage / 5,
        backgroundColor: Colors.grey[400],
        barRadius: Radius.circular(CommonConstants.device_height / 50),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: color,
      ),
    );
  }

  _buildReviewsList() {
    return Container(
      // height: 300,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ReviewList.timeList.length,
          itemBuilder: (BuildContext context, int index) {
            return ReviewListTile(
              name: ReviewList.timeList[index].name,
              imageUrl: ReviewList.timeList[index].imageUrl,
              rating: ReviewList.timeList[index].rating,
              review: ReviewList.timeList[index].review,
              isReplied: ReviewList.timeList[index].isReplied,
              repliedDate: ReviewList.timeList[index].repliedDate,
              repliedText: ReviewList.timeList[index].repliedText,
              repliedUserName: ReviewList.timeList[index].repliedUserName,
            );
          }),
    );
  }
}