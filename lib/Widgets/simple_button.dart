import 'package:flutter/material.dart';

class BtnWidget extends StatefulWidget {
  BtnWidget({Key? key, this.ontap, this.lable,this.height,this.width}) : super(key: key);
  Function? ontap;
  String? lable;
  double? height;
  double? width;

  @override
  _BtnWidgetState createState() => _BtnWidgetState();
}

class _BtnWidgetState extends State<BtnWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.ontap!();
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.yellow[600],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black87.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            "${widget.lable}",
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
