import 'dart:convert';

import 'package:astro/Constant/api_constant.dart';
import 'package:astro/Constant/payment_variables.dart';
import 'package:astro/Widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';


class PaymentInfo extends StatefulWidget {
   PaymentInfo({Key? key,this.selectedAmount}) : super(key: key);

   String? selectedAmount;

  @override
  _PaymentInfoState createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {

  late Razorpay razorpay;
  double? gstamount;
  double? totalpayableamount;
  String? razorpayAmount;
  int? apiAmount;

  addGSTtoAmount(){

    var cgstamount = double.parse("${widget.selectedAmount}")/18;
    var ctotalpayableamount = double.parse("${widget.selectedAmount}");

    // var ctotalpayableamount = double.parse("${widget.selectedAmount}")+ cgstamount;

setState(() {
  gstamount = double.parse("$cgstamount");
  totalpayableamount = double.parse("$ctotalpayableamount") ;
});
setrazorpayamount();
  }
  void setrazorpayamount(){
    var tempvalue = totalpayableamount?.toStringAsFixed(2);
    var razorpayconvert = double.parse("$tempvalue") * 100 ;
    apiAmount = razorpayconvert.toInt();
    setState(() {
      razorpayAmount = razorpayconvert.toString();

    });
}
  @override
  void initState() {
  super.initState();
  addGSTtoAmount();
  razorpay = new Razorpay();
  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Payment Information"),
          backgroundColor: Colors.yellow[600],
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Details",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    build_paymentdetail_row(
                        "Total Amount", Colors.black, "${widget.selectedAmount}", FontWeight.w300),
                    const SizedBox(
                      height: 12,
                    ),
                    build_paymentdetail_row(
                        "GST (18%)", Colors.black, "${gstamount?.toStringAsFixed(2)}", FontWeight.w300),
                    const SizedBox(
                      height: 12,
                    ),
                    build_paymentdetail_row("Total Payable Amount",
                        Colors.black, "${totalpayableamount?.toStringAsFixed(2)}", FontWeight.bold)
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                trailing: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {},
                ),
                title: const Text(
                  "5% EXTRA",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                subtitle: const Text(
                  "₹ 25.0 cashback in wallet after recharge",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
              ),
            ),
            BtnWidget(height: 45,width: 200,lable: "Pay now",ontap: ()async{
              await addCashtoAPI();

            },)
          ],
        ));
  }

  Row build_paymentdetail_row(String title, Color textcolor, String discription,
      FontWeight textfontweight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: textcolor, fontSize: 17, fontWeight: textfontweight),
        ),
        Text(
          "₹ $discription",
          style: TextStyle(
              color: textcolor, fontSize: 17, fontWeight: textfontweight),
        )
      ],
    );
  }



  Future<void> addCashtoAPI() async {


      final uri = Uri.parse(APIConstants.BaseURL + APIConstants.AddMoneyURL  );
      final headers = {'Content-Type': 'application/json',};
      Map<String, dynamic> body = {
        "u_name":"naresh Kumar",
        "u_mobile":"9940471372",
        "amount":"$apiAmount"
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      Response response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,

      );

      int statusCode = response.statusCode;
      String responseBody = response.body;
      var res = jsonDecode(responseBody);
      if (statusCode == 200) {
        Fluttertoast.showToast(msg: "Order Id = ${res["order_ID"]}");
        setState(() {
          PaymentVariables.order_id = res["order_ID"];
        });
        openCheckout("${res["order_ID"]}");
      }
      else{
        Fluttertoast.showToast(msg: response.statusCode.toString());
      }
    }

  Future<void> verifyPayment(String paymentID) async {


    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.VerifyPaymentURL  );
    final headers = {'Content-Type': 'application/json',};
    Map<String, dynamic> body = {
      "u_name":"naresh Kumar",
      "u_mobile":"9940471372",
      "amount":"$apiAmount",
      "order_id":"order_IlDcxFB4EMmFmZ",
      "razorpay_payment_id":paymentID,
      "razorpay_signature":"5db7a9ded10af686c2553318b06fc891e30bf0889bc6f02b500d3b10a05b5d27"
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,

    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    // var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      Fluttertoast.showToast(msg: responseBody);


    }
    else{
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    if(response.paymentId != null || response.paymentId != ""){
      PaymentVariables.payment_id = response.paymentId;
      verifyPayment("${response.paymentId}");
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + "${response.message}",
        toastLength: Toast.LENGTH_SHORT);
    print("------------>>>>>>>..error"+"${response.message}");

  }

  void handleExternalWallet(ExternalWalletResponse response) {

  }

  void openCheckout(String orderID) async {

    var options = {
      "key": "rzp_test_He4GbelHZ5l3RD",
      "amount": "$razorpayAmount", // Convert Paisa to Rupees
      "name": "Astro Talk",
      "description": "desc",
      "timeout": "180",
      "theme.color": "#1B4670",
      "currency": "INR",
      "prefill": {"contact": "9601603600", "email": "harshbavishii@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };




    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> createOrder() async{
    // String key = "https://api.razorpay.com/v1/orders";

    var key = "https://api.razorpay.com/v1/orders";
    final uri = Uri.parse(key);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "amount":50000,
      "currency":"INR",
      "receipt":"order_rcptid_11"
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,

    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    // var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      print(responseBody);

      Fluttertoast.showToast(msg: "got Succesfully");
    }
    else{
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }


  }
}
