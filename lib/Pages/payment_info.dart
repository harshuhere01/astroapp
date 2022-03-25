import 'dart:convert';
import 'dart:io';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/payment_variables.dart';
import 'package:astro/Model/API_Model.dart';
import 'package:astro/Widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentInfo extends StatefulWidget {
  PaymentInfo({Key? key, this.selectedAmount}) : super(key: key);

  String? selectedAmount;

  @override
  _PaymentInfoState createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {
  late Razorpay razorpay;
  double? gstamount;
  double? totalpayableamount;
  String? razorpayAmount;
  double? apiAmount;
  bool isLoading = false;

  addGSTtoAmount() {
    var cgstamount = double.parse("${widget.selectedAmount}") * 18 / 100;
    // var ctotalpayableamount = double.parse("${widget.selectedAmount}");

    var ctotalpayableamount =
        double.parse("${widget.selectedAmount}") + cgstamount;


    setState(() {
      gstamount = double.parse("$cgstamount");
      totalpayableamount = double.parse("$ctotalpayableamount");
    });
    setrazorpayamount();
  }

  void setrazorpayamount() {
    var addmoneyAPIAmount = double.parse("${widget.selectedAmount}");
    var tempvalue = addmoneyAPIAmount.toStringAsFixed(2);
    var razorpayconvert = double.parse(tempvalue) * 100;
    apiAmount = razorpayconvert;
    setState(() {

      razorpayAmount = razorpayconvert.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    addGSTtoAmount();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
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
                    build_paymentdetail_row("Total Amount", Colors.black,
                        "${widget.selectedAmount}", FontWeight.w300),
                    const SizedBox(
                      height: 12,
                    ),
                    build_paymentdetail_row("GST (18%)", Colors.black,
                        "${gstamount?.toStringAsFixed(2)}", FontWeight.w300),
                    const SizedBox(
                      height: 12,
                    ),
                    build_paymentdetail_row(
                        "Total Payable Amount",
                        Colors.black,
                        "${totalpayableamount?.toStringAsFixed(2)}",
                        FontWeight.bold)
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
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : BtnWidget(
                    height: 45,
                    width: 200,
                    lable: " Pay now",
                    ontap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final result =
                            await InternetAddress.lookup('example.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          print('Internet connected');
                          await addMoneyAPI(apiAmount);
                        }
                      } on SocketException catch (_) {
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(
                            msg:
                                '"There is no internet connection , please turn on your internet."');
                      }
                      // openCheckout();
                    },
                  )
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

  addMoneyAPI(apiAmount) async {
    var response = await API().addMoneyAPI(apiAmount);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      // Fluttertoast.showToast(msg: responseBody);
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('internet connected');
          openCheckout("${res['data']['orderId']}");
        }
      } on SocketException catch (_) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg:
                'There is no internet connection , please turn on your internet.');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: 'AddMoneyAPI API error :- ${response.statusCode.toString()}');
    }
  }

  verifyPayment(String orderID, String paymentID, String signature) async {
    var response =
        await API().verifyPayment(orderID, paymentID, signature, apiAmount!);

    int statusCode = response.statusCode;
    String responseBody = response.body;
    // var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      // Fluttertoast.showToast(msg: responseBody);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: 'VerifyPayment API error :- ${response.statusCode.toString()}');
    }
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.paymentId != null || response.paymentId != "") {
      PaymentVariables.payment_id = response.paymentId;
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('internet connected');
          verifyPayment("${response.orderId}", "${response.paymentId}",
              "${response.signature}");
        }
      } on SocketException catch (_) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg:
                '"There is no internet connection , please turn on your internet."');
      }
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isLoading = false;
    });
    var res = jsonDecode("${response.message}");
    Fluttertoast.showToast(
      msg: res['error']['description'],
    );
    print("------------>>>>>>>..error" + "${response.message}");
  }

  void handleExternalWallet(ExternalWalletResponse response) {}

  void openCheckout(String OrderID) async {
    // var id = await generateOrderId("rzp_test_Feaa1lopTSehMR","8zCaOyWVVpXmvSueI10woby6",apiAmount!);
    var options = {
      "key": PaymentVariables.api_key,
      "amount": "$razorpayAmount",
      // Convert Paisa to Rupees
      "name": "Astro Talk",
      "description": "desc",
      "timeout": "180",
      'order_id': OrderID,
      "theme.color": "#1B4670",
      "currency": "INR",
      "prefill": {"contact": "", "email": CommonConstants.userEmail},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('internet connected');
          razorpay.open(options);
        }
      } on SocketException catch (_) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg:
                '"There is no internet connection , please turn on your internet."');
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

// for create order from frontend
/*Future<void> createOrder() async {
    var key = "https://api.razorpay.com/v1/orders";
    final uri = Uri.parse(key);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "amount": 50000,
      "currency": "INR",
      "receipt": "order_rcptid_11"
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
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "got Succesfully");
    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }*/

// for generate orderID From Frontend
/*Future<String> generateOrderId(String key, String secret, int amount) async {
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };
    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: headers, body: data);
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    print('ORDER ID response => ${res.body}');

    return json.decode(res.body)['id'].toString();
  }*/
}
