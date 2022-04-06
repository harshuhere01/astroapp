import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserListTile extends StatelessWidget {
  UserListTile(
      {Key? key,
      this.imageURL,
      this.userName,
      this.designation,
      this.totalnum,
      this.languages,
      this.onTapImage,
      this.experience,
      this.charge,this.btncolor,
      this.waitingstatus,required this.btnbordercolor,
      this.callbtnclick,
      this.onTapOfTile})
      : super(key: key);
  String? imageURL;
  String? userName;
  String? designation;
  String? totalnum;
  String? charge;
  String? languages;
  String? experience;
  String? waitingstatus;
  MaterialStateProperty<Color>? btncolor;
  Color btnbordercolor;
  Function? onTapImage;
  Function? onTapOfTile;
  Function? callbtnclick;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: CommonConstants.device_height*0.2,
      padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      onTapImage!();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black38,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          width: CommonConstants.device_width/5,
                          height: CommonConstants.device_width/5,
                          placeholder: const AssetImage("asset/placeholder.png"),
                          image: NetworkImage("$imageURL"),
                        ),
                      ),
                    )
                    // FadeInImage(
                    //   image: NetworkImage("$imageURL"),
                    //   placeholder: const AssetImage('asset/placeholder.png'),
                    // ),
                    ),
                StarRating(
                  color: Colors.black,
                  rating: 5,
                  starCount: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_rounded,
                      size: 15,
                    ),
                    Text(
                      "$totalnum " "total",
                      style: GoogleFonts.openSans(color: Colors.black, fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$userName",
                          style: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      Text("$designation",
                          style: GoogleFonts.openSans(
                              color: Colors.black45, fontSize: 10)),
                      Text("$languages",
                          style: GoogleFonts.openSans(
                              color: Colors.black45, fontSize: 10)),
                      Text("$experience",
                          style: GoogleFonts.openSans(
                              color: Colors.black45, fontSize: 10)),
                      Text("$charge",
                          style: GoogleFonts.openSans(
                              color: Colors.black87, fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                          const Icon(
                            Icons.verified,
                            size: 25,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: CommonConstants.device_height/20,
                            width: CommonConstants.device_width/5,
                            child: TextButton(
                              child:  Text("Call",
                                  style: GoogleFonts.openSans(fontSize: 14)),
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(10)),
                                  foregroundColor:
                                      btncolor,
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side:  BorderSide(
                                              color: btnbordercolor)))),
                              onPressed: () {
                                  callbtnclick!();
                              },
                            ),
                          ),
                          Text(
                            "$waitingstatus",
                            style: GoogleFonts.openSans(
                                color: Colors.red, fontSize: 10),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
