import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/Drawer%20Pages/Call%20History/incomingCallPage.dart';
import 'package:astro/Pages/Drawer%20Pages/Call%20History/outgoingCallHistory.dart';
import 'package:astro/Widgets/callLogCard.dart';
import 'package:astro/Widgets/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({Key? key}) : super(key: key);

  @override
  _CallHistoryPageState createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage>
    with AutomaticKeepAliveClientMixin<CallHistoryPage> {
  @override
  bool get wantKeepAlive => true;

  /// for Page View
  int _selectedPage = 0;
  bool isPageSelected = false;
  PageController _pageController = PageController(
    keepPage: true,
  );

  /// others
  List<dynamic>? callLogList = [];
  List<dynamic>? incomingCallLogs = [];
  List<dynamic>? outgoingCallLogs = [];
  bool isLoading = false;
  String callDateTime = '';

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  void initState() {
    getCallLogs(CommonConstants.userID, CommonConstants.userIsMember);
    _pageController = PageController();
    setState(() {
      isLoading = true;
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.yellow[600],
        title: const Text("Call logs"),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: CommonConstants.userIsMember
          ? Column(
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TabButton(
                            selectedPage: _selectedPage,
                            pageNumber: 0,
                            text: "Incoming calls",
                            onPressed: () {
                              _changePage(0);
                            }),
                      ),
                      Expanded(
                        flex: 2,
                        child: TabButton(
                            selectedPage: _selectedPage,
                            pageNumber: 1,
                            text: "Outgoing calls",
                            onPressed: () {
                              _changePage(1);
                            }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (int page) {
                      setState(() {
                        _selectedPage = page;
                      });
                    },
                    controller: _pageController,
                    children: [
                      IncomingCallHistory(
                        callLogList: incomingCallLogs,
                        isLoading: isLoading,
                      ),
                      OutgoingCallHistory(
                        callLogList: outgoingCallLogs,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : callLogList == null
                  ? const Center(child: Text("No calls yet !!!"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: callLogList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        formatCallTime(callLogList![index]['createdAt'] ?? '');
                        return CallLodCard(
                          calltypeIcon: callLogList![index]['call_type'] ==
                                  CommonConstants.outgoingCall
                              ?  Icon(
                                  Icons.call_made,
                                  color: callLogList![index]['duration'] == null
                                      ? Colors.red
                                      : Colors.green,
                                  size: 17,
                                )
                              :  Icon(
                                  Icons.call_received,
                                  color: callLogList![index]['duration'] == null
                                      ? Colors.red
                                      : Colors.green,
                                  size: 17,
                                ),
                          callerName:
                              callLogList![index]['members']['name'] ?? '',
                          // calltimeStamp: callDateTime,
                          callDuration: callLogList![index]['duration'] ?? '',
                          calltimeStamp: callDateTime,
                          profileURL: callLogList![index]['members']['photo'],
                        );
                      },
                    ),
    );
  }

  Future<void> getCallLogs(int userID, bool isMember) async {
    var response = await API().getCallLogs(userID, isMember);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        callLogList = res['data'];
        isLoading = false;
      });
      if (isMember) {
        await sortIncomingCallLog();
      }
    } else {
      Fluttertoast.showToast(
          msg: "getCallLogs API error :- ${response.statusCode.toString()}");
    }
  }

  formatCallTime(date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString())
        .add(const Duration(hours: 5, minutes: 30));
    var outputFormat = DateFormat('d MMMM hh:mm a');
    var outputDate = outputFormat.format(inputDate.toLocal());

    callDateTime = outputDate;
  }

  Future<void> sortIncomingCallLog() async {
    if (callLogList != null) {
      for (int i = 0; i < callLogList!.length; i++) {
        if (callLogList![i]['call_type'] == "Incoming") {
          incomingCallLogs!.add(callLogList![i]);
          print("Incoming call list :::::::::---------$incomingCallLogs");
        } else {
          outgoingCallLogs!.add(callLogList![i]);
          print("outgoing call list :::::::::---------$outgoingCallLogs");
        }
      }
    } else {
      print("callLogList  :::::::::---------$callLogList ");
    }
  }
}
