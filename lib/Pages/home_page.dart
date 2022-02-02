import 'dart:convert';

import 'package:astro/Constant/api_constant.dart';
import 'package:astro/Pages/call_page.dart';
import 'package:astro/Pages/chat_page.dart';
import 'package:astro/Widgets/simple_button.dart';
import 'package:astro/Widgets/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.userList}) : super(key: key);

  List<dynamic>? userList;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;
  int _selectedPage = 0;
  bool isPageSelected = false;
  PageController _pageController = PageController(
    keepPage: true,
  );

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
    _pageController = PageController();
    walletBalance="";
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  String? walletBalance;
  String buttonName = "Check wallet balance";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tepped Search")));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tepped Settings")));
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              )),
        ],
        backgroundColor: Colors.yellow[600],
        title: const Text("Call with Astrologer"),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 200,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black87.withOpacity(0.1)),
                  ),

                  padding: const EdgeInsets.all(2),
                  child: TextButton(onPressed: ()async{
                    await getWalletBalance();
                  }, child: Text(buttonName,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w300),),),),
              walletBalance==null|| walletBalance==""? Container(): Text("Your wallet Balance is : ₹ $walletBalance",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w300),),
            ],
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: TabButton(
                      selectedPage: _selectedPage,
                      pageNumber: 0,
                      text: "Chat",
                      onPressed: () {
                        _changePage(0);
                      }),
                ),
                Expanded(
                  flex: 2,
                  child: TabButton(
                      selectedPage: _selectedPage,
                      pageNumber: 1,
                      text: "Call",
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
                  buttonName = "Check wallet balance";
                  walletBalance="";
                });
              },
              controller: _pageController,
              children: [
                widget.userList!.isEmpty
                    ? const Center(
                      child:  CircularProgressIndicator(
                          color: Colors.black,
                        ),
                    )
                    : ChatPage(
                        itemlist: widget.userList,
                      ),
                widget.userList!.isEmpty
                    ? const Center(
                      child:  CircularProgressIndicator(
                          color: Colors.black,
                        ),
                    )
                    : CallPage(
                        itemlist: widget.userList,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getWalletBalance() async {

    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.GetWalletAmountURL);
    final headers = {'Content-Type': 'application/json',};
    Map<String, dynamic> body = {
      "u_mobile":"9601603600"
    };
    String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      // encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        walletBalance = res["wallet_amount"];
        buttonName = "Check balance again";
      });
      // Fluttertoast.showToast(msg: responseBody);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wallet Amount is :- ${res["wallet_amount"]}")));


    }
    else{
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }
}
