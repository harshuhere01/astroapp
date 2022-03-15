import 'dart:convert';

import 'package:astro/Constant/CommonConstant.dart';
import 'package:astro/Constant/agora_variables.dart';
import 'package:astro/Constant/api_constant.dart';
import 'package:http/http.dart';

class API {
  Future<Response> fetchUsers() async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.getAllUsers);
    final headers = {
      'Content-Type': 'application/json',
    };
    Response response = await get(
      uri,
      headers: headers,
    );
    return response;
  }

  Future<Response> getAllMember(id) async {
    final uri =
    Uri.parse(APIConstants.baseURL + APIConstants.getAllMember + "/$id");
    final headers = {
      'Content-Type': 'application/json',
    };
    Response response = await get(
      uri,
      headers: headers,
    );
    return response;
  }

  Future<Response> getSingelUser(id) async {
    final uri =
    Uri.parse(APIConstants.baseURL + APIConstants.getSingelUser + "/$id");
    final headers = {
      'Content-Type': 'application/json',
    };

    Response response = await get(
      uri,
      headers: headers,
    );
    return response;
  }

  Future<Response> getBalance(id) async {
    final uri =
    Uri.parse(APIConstants.baseURL + APIConstants.getBalance + "/$id");
    final headers = {
      'Content-Type': 'application/json',
    };
    Response response = await get(
      uri,
      headers: headers,
    );
    return response;
  }

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

  Future<Response> getCallLogs(int userID, bool isMember) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.getCallLogs);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"userId": userID, "isMember": isMember};
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
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.sendNotification);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "username": CommonConstants.userName,
      "fcm_token": CommonConstants.receiverFCMToken,
      "channelName": Agora.Channel_name,
      "agora_token": Agora.Token,
      "receiverId": CommonConstants.receiverIdforSendNotification,
      "app_id": Agora.APP_ID,
      "callerId": CommonConstants.userID,
      "socketId": CommonConstants.socketID,
      "callLogId": CommonConstants.callerCallLogId,
    };
    String jsonBody = json.encode(body);

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
    );
    return response;
  }

  Future<Response> addMoneyAPI(double apiAmount) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.addMoneyURL);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "id": CommonConstants.userID,
      "amount": apiAmount
    };
    String jsonBody = json.encode(body);

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
    );
    return response;
  }

  Future<Response> verifyPayment(String orderID, String paymentID,
      String signature, double apiAmount) async {
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

  // Future<Response> calculateTime(String uMobile, String cCharge) async {
  //   final uri = Uri.parse(APIConstants.baseURL + APIConstants.calculateTime);
  //   final headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   Map<String, dynamic> body = {
  //     "u_mobile": uMobile,
  //     "c_charge": cCharge,
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

  Future<Response> registerUser(String name,
      String email,
      String photoURL,
      String fcmToken,
      String age,
      String gender,
      String mobile,) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.registerUser);
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "photo": photoURL,
      "fcm_token": fcmToken,
      "isMember": false,
      "isActive": true,
      "available": "yes",
      "age": age,
      "sex": gender,
      "mobile": mobile,
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
      "id": CommonConstants.userID,
      "fcm_token": CommonConstants.userFCMToken,
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

  Future<Response> updateUser(String name,
      String age,
      String gender,
      String mobile,
      String available,
      String callRate,
      String achievements,
      String socialmediaLink,
      String aboutMe,) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.updateUser);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "id": CommonConstants.userID,
      "name": name,
      "email": CommonConstants.userEmail,
      "photo": CommonConstants.userPhoto,
      "age": age,
      "sex": gender,
      "mobile": mobile,
      "available": available,
      "call_rate": callRate,
      "achievements": achievements,
      "social_media_link": socialmediaLink,
      "about_me": aboutMe,
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

  Future<Response> createMember(int userId,
      double callRate,
      String socialMediaLink,
      String aboutMe,
      String achievements,
      String status,) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.createMember);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "userId": userId,
      "call_rate": callRate,
      "social_media_link": socialMediaLink,
      "about_me": aboutMe,
      "achievements": achievements,
      "status": status
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

  Future<Response> startVideoCallAPI(String cCharge) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.startVideoCall);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "id": CommonConstants.userID,
      "c_charge": cCharge,
      "memberId": CommonConstants.receiverIdforSendNotification,
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

  Future<Response> createCallLog(int userID, String callType, bool isMember,
      int receiverID) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.createCallLog);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "userId": userID,
      "memberId": receiverID,
      "call_type": callType,
      "isMember": isMember
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

  Future<Response> updateDuration(int calllogid, String duration) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.updateDuration);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "id": calllogid,
      "duration": duration
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

  Future<Response> changeAvailabilty(int userID, String status) async {
    final uri = Uri.parse(APIConstants.baseURL + APIConstants.changeAvailabilty);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "id": userID,
      "status": status
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


