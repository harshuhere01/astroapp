import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  DisplayImage({Key? key, this.imageURL}) : super(key: key);
  String? imageURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.network(
        "$imageURL",
        fit: BoxFit.contain,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
