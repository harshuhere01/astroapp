import 'package:astro/Constant/CommonConstant.dart';
import 'package:flutter/material.dart';

class CallLodCard extends StatelessWidget {
  CallLodCard({
    Key? key,
    this.callerName,
    this.calltimeStamp,
    this.profileURL,
    required this.calltypeIcon,
  }) : super(key: key);
  String? callerName;
  String? calltimeStamp;
  String? profileURL;
  Icon calltypeIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
      // decoration: const BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.all(Radius.circular(20)),
      // ),
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
                  onTap: () {},
                  child: Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.black,
                    //   ),
                    //   shape: BoxShape.circle,
                    // ),
                    child: ClipOval(
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        width: CommonConstants.device_width / 7,
                        height: CommonConstants.device_width / 7,
                        placeholder: const AssetImage("asset/placeholder.png"),
                        image: NetworkImage("$profileURL"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$callerName",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 1,),
                      Row(
                        children: [
                          calltypeIcon,
                          Text(
                            "$calltimeStamp",
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
