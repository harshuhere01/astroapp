import 'package:flutter/material.dart';

class IdCard extends StatefulWidget {
  IdCard(
      {Key? key,
      this.imageURL,
      this.userName,
      this.cityName,
      this.onTapImage,
      this.onTapOfTile})
      : super(key: key);

  String? imageURL;
  String? userName;
  String? cityName;
  Function? onTapImage;
  Function? onTapOfTile;
  @override
  _IdCardState createState() => _IdCardState();
}

class _IdCardState extends State<IdCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        // height: 50,
        // color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: InkWell(
                onTap: () {
                  widget.onTapImage!();
                },
                child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage("${widget.imageURL}")),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.grey[800],
            ),
            InkWell(
              onTap: () {
                widget.onTapOfTile!();
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Name : ',
                        style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 1.0,
                            fontSize: 12),
                      ),
                      Flexible(
                        child: Text(
                          '${widget.userName}',
                          style: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.0,
                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Cityname : ',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      Text(
                        '${widget.cityName}',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
