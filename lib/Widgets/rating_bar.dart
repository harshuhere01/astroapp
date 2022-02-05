import 'package:astro/Constant/CommonConstant.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;

  StarRating({this.starCount = 5, this.rating = .0, required this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        size: CommonConstants.device_width*0.043,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        size: CommonConstants.device_width*0.043,
        color: color,
      );
    } else {
      icon = Icon(
        Icons.star,
        size: CommonConstants.device_width*0.043,
        color: color,
      );
    }
    return InkResponse(
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}
