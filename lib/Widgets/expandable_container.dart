import 'package:astro/Constant/CommonConstant.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMe extends StatelessWidget {
  AboutMe({Key? key,required this.aboutMe}) : super(key: key);

  String aboutMe ;

  @override
  Widget build(BuildContext context) {
    buildCollapsed1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "About me",
                      softWrap: true,
                      style: GoogleFonts.muli(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: CommonConstants.device_height / 45),
                    ),
                  ),
                  Text(aboutMe,
                      maxLines: 3,
                      style: GoogleFonts.muli(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600])),
                ],
              ),
            ),
          ]);
    }

    buildExpanded1() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "About me",
                softWrap: true,
                style: GoogleFonts.muli(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: CommonConstants.device_height / 45),
              ),
            ),
            Text(
              aboutMe,
              softWrap: true,
                style: GoogleFonts.muli(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600])
            ),
          ],
        ),
      );
    }

    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expandable(
              collapsed: buildCollapsed1(),
              expanded: buildExpanded1(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Builder(
                  builder: (context) {
                    var controller =
                        ExpandableController.of(context, required: true)!;
                    return controller.expanded ? const SizedBox() : Padding(
                      padding: EdgeInsets.only(
                          bottom: CommonConstants.device_height / 100),
                      child: InkWell(
                        onTap: () {
                          controller.toggle();
                        },
                        child: Container(
                          height: CommonConstants.device_height / 32,
                          width: CommonConstants.device_width / 4,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 1,
                              ),
                            ],
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.black45, width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                CommonConstants.device_width / 8)),
                          ),
                          child: Center(
                            child: Text(
                                controller.expanded ? "COLLAPSE" : "Read More",
                                style: GoogleFonts.muli(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        CommonConstants.device_width / 30)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
