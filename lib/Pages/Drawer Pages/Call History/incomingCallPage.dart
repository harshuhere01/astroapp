import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Widgets/callLogCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class IncomingCallHistory extends StatefulWidget {
  IncomingCallHistory(
      {Key? key, required this.callLogList, required this.isLoading})
      : super(key: key);
  List<dynamic>? callLogList;
  bool isLoading;

  @override
  _IncomingCallHistoryState createState() => _IncomingCallHistoryState();
}

class _IncomingCallHistoryState extends State<IncomingCallHistory> {
  String callDateTime = '';

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
        : widget.callLogList!.isEmpty
            ?  Center(child: Text("No calls yet !!!",style: GoogleFonts.muli(),))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: widget.callLogList!.length,
                itemBuilder: (BuildContext context, int index) {
                  formatCallTime(widget.callLogList![index]['createdAt'] ?? '');
                  return CallLodCard(
                    calltypeIcon: widget.callLogList![index]['call_type'] ==
                            CommonConstants.outgoingCall
                        ? Icon(
                            Icons.call_made,
                            color:
                                widget.callLogList![index]['duration'] == null
                                    ? Colors.red
                                    : Colors.green,
                            size: 17,
                          )
                        : Icon(
                            Icons.call_received,
                            color:
                                widget.callLogList![index]['duration'] == null
                                    ? Colors.red
                                    : Colors.green,
                            size: 17,
                          ),
                    callDuration: widget.callLogList![index]['duration'] ?? '',
                    callerName:
                        widget.callLogList![index]['members']['name'] ?? '',
                    calltimeStamp: callDateTime,
                    profileURL: widget.callLogList![index]['members']['photo'],
                  );
                },
              );
  }

  formatCallTime(date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString())
        .add(const Duration(hours: 5, minutes: 30));
    var outputFormat = DateFormat('d MMMM hh:mm a');
    var outputDate = outputFormat.format(inputDate.toLocal());

    callDateTime = outputDate;
  }
}
