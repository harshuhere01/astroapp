import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Widgets/expandable_container.dart';
import 'package:astro/Widgets/member_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberProfilePage extends StatefulWidget {
  const MemberProfilePage({Key? key}) : super(key: key);

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage> {
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
              margin: EdgeInsets.symmetric(vertical: 14),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.whatsapp_rounded,
                      color: Colors.green,
                      size: 17,
                    ),
                    SizedBox(
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
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tapped Settings")));
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              )),
        ],
      ),
      body: Column(
        children: [
          MemberProfileCard(
              imageURL: 'https://picsum.photos/200/300',
              userName: 'User',
              charge: '₹ 20/min',
              experience: 'Exp: 8 Years',
              languages: 'English, Hindi, Urdu',
              designation: 'Astrologer'),
      Container(
        // height: 400,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children:[
            AboutMe(),
          ],
        ),
      ),
        ],
      ),
    );
  }


}

