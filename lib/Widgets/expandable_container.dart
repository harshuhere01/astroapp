import 'package:astro/main.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMe extends StatelessWidget {
   AboutMe({Key? key}) : super(key: key);

  String aboutMe =
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";



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
                  Text(aboutMe, maxLines: 3, style: GoogleFonts.muli()),
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
          children:  [
            Text(
              aboutMe,
              softWrap: true,
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
                        return TextButton(
                          child: Text(
                            controller.expanded ? "COLLAPSE" : "EXPAND",
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(color: Colors.deepPurple),
                          ),
                          onPressed: () {
                            controller.toggle();
                          },
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