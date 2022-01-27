import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Widgets/rating_bar.dart';
import 'package:flutter/material.dart';

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
        this.age,
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
  int? age;
  Function? onTapImage;
  Function? onTapOfTile;
  Function? callbtnclick;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    child: ClipOval(
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        width: CommonConstants.device_width/5.5,
                        height: CommonConstants.device_height/9.2,
                        placeholder: const AssetImage("asset/placeholder.png"),
                        image: NetworkImage("$imageURL"),
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
                      style: const TextStyle(color: Colors.black, fontSize: 10),
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
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      Text("$designation",
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 10)),
                      Text("$languages",
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 10)),
                      Text("$experience",
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 10)),
                      Text("$charge",
                          style: const TextStyle(
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
                              child: const Text("Call",
                                  style: TextStyle(fontSize: 14)),
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
                              onPressed:age! > 60 ? null : age! < 40 ? null : () {
                                callbtnclick!();
                              },
                            ),
                          ),
                          Text(
                            "$waitingstatus",
                            style: const TextStyle(
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
