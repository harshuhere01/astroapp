import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewListTile extends StatelessWidget {
  ReviewListTile({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.review,
    required this.repliedUserName,
    required this.repliedDate,
    required this.repliedText,
    required this.isReplied,
  }) : super(key: key);
  String? name;
  double? rating;
  String? imageUrl;
  String? review;
  String? repliedUserName;
  String? repliedDate;
  String? repliedText;
  bool? isReplied;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: CommonConstants.device_height / 100,
            horizontal: CommonConstants.device_width / 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      width: CommonConstants.device_width / 15,
                      height: CommonConstants.device_width / 15,
                      placeholder: const AssetImage("asset/placeholder.png"),
                      image: AssetImage(imageUrl!),
                    ),
                  ),
                ),
                SizedBox(
                  width: CommonConstants.device_width / 40,
                ),
                Text(name!,
                    style: GoogleFonts.muli(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: CommonConstants.device_height / 50,
                    ))
              ],
            ),
            SizedBox(
              height: CommonConstants.device_height / 150,
            ),
            StarRating(
                color: Colors.grey[600],
                starCount: 5,
                rating: rating!,
                alignStart: true),
            SizedBox(
              height: CommonConstants.device_height / 150,
            ),
            Text(
              review!,
              style: GoogleFonts.muli(
                  color: Colors.grey[600],
                  fontSize: CommonConstants.device_height / 60,
                  fontWeight: FontWeight.w300),
            ),
           isReplied! ? Container(
              // height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.all(Radius.circular(CommonConstants.device_height/100)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: CommonConstants.device_width / 40,
                        vertical: CommonConstants.device_height / 250),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(repliedUserName!,
                            style: GoogleFonts.muli(
                                color: Colors.black,
                                fontSize: CommonConstants.device_height / 60,
                                fontWeight: FontWeight.w500)),
                        Text(repliedDate!,
                            style: GoogleFonts.muli(
                                color: Colors.black54,
                                fontSize: CommonConstants.device_height / 70,
                                fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: CommonConstants.device_width / 40,
                        vertical: CommonConstants.device_height / 250),
                    child: Text(
                      repliedText!,
                      style: GoogleFonts.muli(
                          color: Colors.grey[600],
                          fontSize: CommonConstants.device_height / 60,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
