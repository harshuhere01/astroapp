import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Pages/payment_info.dart';
import 'package:astro/Widgets/custom_gridview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({Key? key}) : super(key: key);

  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final _balancefieldcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? balance;

  String? amount;
  List<int> itemlist = [
    25,
    50,
    100,
    200,
    300,
    500,
    1000,
    2000,
    3000,
    4000,
    8000,
    15000,
    20000,
    50000,
    100000
  ];

  @override
  void initState() {
    getBalance();
    super.initState();
  }

  @override
  void dispose() {
    _balancefieldcontroller.dispose();
    super.dispose();
  }

  Future<void> getBalance() async {
    var response = await API().getBalance(CommonConstants.userID);
    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        balance = res['data'] != null
            ? res['data']['wallet_amount'] != null
                ? res['data']["wallet_amount"]
                : "0.00"
            : "0.00";
      });
    } else {
      Fluttertoast.showToast(
          msg: "GetBalance API error :- ${response.statusCode.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add money to wallet"),
        backgroundColor: CommonConstants.appcolor,
        titleTextStyle: GoogleFonts.muli(color: Colors.black, fontSize: 18),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(25),
            child: balance == null
                ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                : Text(
                    "Available Balance: ₹ $balance",
                    style: GoogleFonts.muli(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
          ),
          Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: TextFormField(
                onChanged: (value) {
                  amount = _balancefieldcontroller.text;
                },
                controller: _balancefieldcontroller,
                keyboardType: TextInputType.number,
                style:
                    GoogleFonts.muli(fontWeight: FontWeight.w300, fontSize: 18),
                validator: (valuee) {
                  if (valuee == null || valuee.isEmpty) {
                    return "*Enter money";
                  }
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (_formKey.currentState?.validate() == true) {
                          int val = int.parse(_balancefieldcontroller.text);
                          if (val >= 25) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => PaymentInfo(
                                          selectedAmount: amount,
                                        )));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Minimum recharge value is ₹25");
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width / 4.5,
                        decoration: BoxDecoration(
                            color: CommonConstants.appcolor,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Center(
                          child: Text(
                            'Proceed',
                            style: GoogleFonts.muli(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    hintText: 'Enter money'),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                  itemCount: itemlist.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 5),
                ),
                padding: const EdgeInsets.all(40),
                itemCount: itemlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return ClipRect(
                    child: itemlist[index] > 200
                        ? Banner(
                            location: BannerLocation.topStart,
                            message: itemlist[index] <= 500
                                ? '5% Extra'
                                : itemlist[index] <= 4000
                                    ? '10% Extra'
                                    : '15% Extra',
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _balancefieldcontroller.text =
                                      itemlist[index].toString();
                                  amount = _balancefieldcontroller.text;
                                });
                                // var convertedamount = int.parse(_balancefieldcontroller.text) * 100;
                                print("!!!!!!!!!!!!!!!!!$amount");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: const Color(0xFFfeecd4),
                                  border: Border.all(
                                      color: Colors.black87, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: Center(
                                  child: Text(
                                    " ₹ ${itemlist[index].toString()}",
                                    style: GoogleFonts.muli(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                _balancefieldcontroller.text =
                                    itemlist[index].toString();
                                amount = _balancefieldcontroller.text;
                              });
                              print(amount);
                              // ScaffoldMessenger.of(context).clearSnackBars();
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //       content: Text(
                              //           "You've selected ₹ ${itemlist[index]}.")),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: const Color(0xFFfeecd4),
                                border:
                                    Border.all(color: Colors.black87, width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Center(
                                child: Text(
                                  " ₹ ${itemlist[index].toString()}",
                                  style: GoogleFonts.muli(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
