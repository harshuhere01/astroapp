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
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.getAllUsers);
    final headers = {
      'Content-Type': 'application/json',
    };
    // final encoding = Encoding.getByName('utf-8');
    Response response = await get(
      uri,
      headers: headers,
      // encoding: encoding,
    );
    return response;
  }

  Future<Response> getAllMember(id) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.getAllMember +"/$id");
    final headers = {
      'Content-Type': 'application/json',
    };
    // final encoding = Encoding.getByName('utf-8');
    Response response = await get(
      uri,
      headers: headers,
      // encoding: encoding,
    );
    return response;
  }

  Future<Response> getBalance(id) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.getBalance +"/$id");
    final headers = {
      'Content-Type': 'application/json',
    };
    // final encoding = Encoding.getByName('utf-8');
    Response response = await get(
      uri,
      headers: headers,
      // encoding: encoding,
    );
    return response;
  }

  // Future<Response> getWalletBalance() async {
  //   final uri =
  //   Uri.parse(APIConstants.baseURL + APIConstants.getWalletAmountURL);
  //   final headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   Map<String, dynamic> body = {"u_mobile": "9601603611"};
  //   String jsonBody = json.encode(body);
  //   // final encoding = Encoding.getByName('utf-8');
  //
  //   Response response = await post(
  //     uri,
  //     headers: headers,
  //     body: jsonBody,
  //     // encoding: encoding,
  //   );
  //   return response;
  // }

  Future<Response> createToken(String userID) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.createToken);
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
    Uri.parse(APIConstants.baseURL + APIConstants.sendNotification);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "username" : CommonConstants.userName,
      "fcm_token": CommonConstants.receiverFCMToken,
      "channelName": Agora.Channel_name,
      "agora_token": Agora.Token,
      "receiverId":CommonConstants.receiverIdforSendNotification,
      "app_id" : Agora.APP_ID,
      "callerId" : CommonConstants.userID,
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
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.addMoneyURL);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "id" : CommonConstants.userID,
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
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.verifyPaymentURL);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
     "id": CommonConstants.userID,
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
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.calculateTime);
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

  Future<Response> registerUser(String name,String email,String photoURL,String fcmToken,) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.registerUser);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "photo" :photoURL,
      "fcm_token":fcmToken,
      "isMember" :false,
      "isActive" :true,
      "available" :"yes",
      // "age": "",
      // "sex" :"",
      // "mobile" :"",

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

  Future<Response> updateFCMToken() async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.updateFCMToken);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "id" : CommonConstants.userID,
      "fcm_token" : CommonConstants.userFCMToken,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await put(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

}