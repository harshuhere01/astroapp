import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberProfileCard extends StatelessWidget {
  MemberProfileCard(
      {Key? key,
      this.imageURL,
      this.userName,
      this.designation,
      this.languages,
      this.onTapImage,
      this.experience,
      this.charge,
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
  Function? onTapImage;
  Function? onTapOfTile;
  Function? callbtnclick;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: CommonConstants.device_height / 4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
         mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3,
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
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                width: CommonConstants.device_width / 5.5,
                                height: CommonConstants.device_width / 5.5,
                                placeholder:
                                    const AssetImage("asset/placeholder.png"),
                                image: NetworkImage("$imageURL"),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: CommonConstants.device_width / 28,
                              vertical: CommonConstants.device_width / 60),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              height: CommonConstants.device_width / 17,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFFdd835),
                                  //  Colors.yellow[600]
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Center(
                                child: Text(
                                  'Follow',
                                  style: GoogleFonts.muli(
                                      color: Colors.black,
                                      fontSize:
                                          CommonConstants.device_width / 38,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:  EdgeInsets.only(left: CommonConstants.device_width/100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("$userName",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text("$designation",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black, fontSize: 10)),
                              Text("$languages",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black, fontSize: 10)),
                              Text("$experience",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black, fontSize: 10)),
                              Text("$charge",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black87, fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_border,
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
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[200],
              thickness: 1,
            ),
            Expanded(

                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.question_answer_outlined),
                    Row(
                      children: [
                        Text(
                          '19K',
                          style: GoogleFonts.muli(fontWeight: FontWeight.bold),
                        ),
                         SizedBox(
                          width: CommonConstants.device_width/100,
                        ),
                        Text(
                          'mins',
                          style: GoogleFonts.muli(),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.call),
                    Row(
                      children: [
                        Text(
                          '18',
                          style: GoogleFonts.muli(fontWeight: FontWeight.bold),
                        ),
                         SizedBox(
                          width: CommonConstants.device_width/100,
                        ),
                        Text(
                          'mins',
                          style: GoogleFonts.muli(),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
