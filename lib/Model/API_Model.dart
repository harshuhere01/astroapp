import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Constant/api_constant.dart';
import 'package:http/http.dart';

class API{
  // Future<Response> ForgotPasswordAPI(String email) async {
  //   final uri = Uri.parse(APIConstants.BaseURL + APIConstants.ForgotPassword);
  //   final headers = {'Content-Type': 'application/json'};
  //   Map<String, dynamic> body = {
  //     "email": email,
  //   };
  //   String jsonBody = json.encode(body);
  //   final encoding = Encoding.getByName('utf-8');
  //
  //   Response response = await post(
  //     uri,
  //     headers: headers,
  //     body: jsonBody,
  //     encoding: encoding,
  //   );
  //   return response;
  // }

  Future<Response> fetchUsers() async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.GetAllUsers);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "u_type": "astrologer",
    };
    String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      // encoding: encoding,
    );
    return response;
  }

  Future<Response> getWalletBalance() async {
    final uri =
    Uri.parse(APIConstants.BaseURL + APIConstants.GetWalletAmountURL);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {"u_mobile": "9601603611"};
    String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      // encoding: encoding,
    );
    return response;
  }

  Future<Response> createToken(String userID) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.CreateToken);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "channel_name": userID,
      "uid": "0",
      "role": "customer",
      "expire_time": "null"
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  Future<Response> send_notification() async {
    final uri =
    Uri.parse(APIConstants.BaseURL + APIConstants.send_notification);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "fcm_token": CommonConstants.receiverFCMToken,
      "channelName": Agora.Channel_name,
      "agora_token": Agora.Token,
      "u_mobile" : "9876543210",
      "receiverId":CommonConstants.receiverIdforSendNotification,
      "app_id" : Agora.APP_ID,
    };
    String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      // encoding: encoding,
    );
    return response;
  }

  Future<Response> addMoneyAPI(int apiAmount) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.AddMoneyURL);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "u_name": "test1",
      "u_mobile": "9601603611",
      "amount": apiAmount
    };
    String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      // encoding: encoding,
    );
    return response;
  }

  Future<Response> verifyPayment(
      String orderID, String paymentID, String signature,int apiAmount) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.VerifyPaymentURL);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "u_name": "test",
      "u_mobile": "9601603611",
      "amount": apiAmount,
      "order_id": orderID,
      "razorpay_payment_id": paymentID,
      "razorpay_signature": signature,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  Future<Response> calculateTime(String uMobile,String cCharge) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.CalculateTime);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "u_mobile": uMobile,
      "c_charge": cCharge,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;


  }

}