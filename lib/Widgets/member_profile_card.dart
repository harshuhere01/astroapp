import 'package:astro/Constant/CommonConstant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberProfileCard extends StatelessWidget {
  MemberProfileCard({Key? key,
    required this.imageURL,
    required this.userName,
    required this.designation,
    required this.languages,
    required this.onTapImage,
    required this.experience,
    required this.charge,
    required this.chatMins,
    required this.callMins,
    required this.callbtnclick,
    })
      : super(key: key);
  String imageURL;
  String userName;
  String designation;
  String charge;
  String languages;
  String experience;
  String chatMins;
  String callMins;
  Function onTapImage;

  Function callbtnclick;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SizedBox(
        height: CommonConstants.device_height / 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: CommonConstants.device_width / 20,
                              vertical: CommonConstants.device_width / 60),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              height: CommonConstants.device_width / 17,
                              decoration:  BoxDecoration(
                                  color: CommonConstants.appcolor,
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
                      padding: EdgeInsets.only(
                          left: CommonConstants.device_width / 100),
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
                                      fontSize: CommonConstants.device_height/50,
                                      fontWeight: FontWeight.bold)),
                              Text("$designation",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black, fontSize: CommonConstants.device_height/70)),
                              Text("$languages",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black, fontSize: CommonConstants.device_height/70)),
                              Text("Exp. $experience",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black, fontSize: CommonConstants.device_height/70)),
                              Text("$charge",
                                  style: GoogleFonts.openSans(
                                      color: Colors.black87, fontSize: CommonConstants.device_height/60)),
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
                              SizedBox(width: CommonConstants.device_width/30,)
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
                flex:2,
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
                              chatMins,
                              style: GoogleFonts.muli(fontWeight: FontWeight
                                  .bold),
                            ),
                            SizedBox(
                              width: CommonConstants.device_width / 100,
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
                              callMins,
                              style: GoogleFonts.muli(fontWeight: FontWeight
                                  .bold),
                            ),
                            SizedBox(
                              width: CommonConstants.device_width / 100,
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
