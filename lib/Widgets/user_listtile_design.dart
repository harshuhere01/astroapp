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
      this.charge,
      this.waitingtime,
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
  String? waitingtime;
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
                        width: 75,
                        height: 75,
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
                            height: 40,
                            width: 90,
                            child: TextButton(
                              child: const Text("Call",
                                  style: TextStyle(fontSize: 14)),
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(10)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              color: Colors.red)))),
                              onPressed: () {
                                callbtnclick!();
                              },
                            ),
                          ),
                          Text(
                            "$waitingtime",
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
