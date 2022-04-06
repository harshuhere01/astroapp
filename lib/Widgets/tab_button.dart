import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabButton extends StatelessWidget {
  // final String text;
  final int selectedPage;
  final int pageNumber;
  final String text;
  final VoidCallback onPressed;
  const TabButton(
      {Key? key,
      // required this.text,
      required this.selectedPage,
      required this.pageNumber,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        padding: EdgeInsets.symmetric(
          vertical: selectedPage == pageNumber ? 10.0 : 10.0,
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
                color:
                    selectedPage == pageNumber ? Colors.black12 : Colors.white),
            color:
                selectedPage == pageNumber ? Colors.yellow[600] : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
          ),
          child: Text(
            text,
            style: GoogleFonts.openSans(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
