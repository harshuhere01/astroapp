import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Widgets/callLogCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OutgoingCallHistory extends StatefulWidget {
  OutgoingCallHistory(
      {Key? key, required this.callLogList, required this.isLoading})
      : super(key: key);
  List<dynamic>? callLogList;
  bool isLoading;

  @override
  _OutgoingCallHistoryState createState() => _OutgoingCallHistoryState();
}

class _OutgoingCallHistoryState extends State<OutgoingCallHistory> {
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
            ? const Center(child: Text("No data found !!!"))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: widget.callLogList!.length,
                itemBuilder: (BuildContext context, int index) {
                  formatCallTime(widget.callLogList![index]['createdAt'] ?? '');
                  return CallLodCard(
                    calltypeIcon: widget.callLogList![index]['call_type'] ==
                            CommonConstants.outgoingCall
                        ? const Icon(
                            Icons.call_made,
                            color: Colors.green,
                            size: 17,
                          )
                        : const Icon(
                            Icons.call_received,
                            color: Colors.green,
                            size: 17,
                          ),
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
    var inputDate = DateTime.parse(parseDate.toString());
    var inputdatewithOffset =
        inputDate.add(const Duration(hours: 5, minutes: 30));
    var outputFormat = DateFormat('d MMMM hh:mm a');
    var outputDate = outputFormat.format(inputdatewithOffset.toLocal());

    callDateTime = outputDate;
  }
}
