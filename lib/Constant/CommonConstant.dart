import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CommonConstants {
  static double device_width = 0;
  static double device_height = 0;
  static String userFCMToken = '';
  static String receiverFCMToken = '';
  static Socket socket = io('http://34.205.139.16:8081', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  static var socketID = '';

  static bool listened = false;

  static late int receiverIdforSendNotification ;
  static late int receiverId ;
  static late int callerId ;
  static String callerSocketId ='' ;
  static late int room ;
  static String joiningchannelName = '';
  static String joiningchannelId = '';
  static String joiningAppId = '';
  static bool caller = false;


  ///user details
  static late int userID ;
  static var userPhoto = '';
  static var userName = '';
  static var userEmail = '';
  static var userAge = '';
  static var userGender = '';
  static var userMobilenumber = '';

  /// call log variables
  static String outgoingCall = 'Outgoing';
  static String incomingCall = 'Incoming';
  static bool userIsMember = false;

  static String calljoinername = '';
  static String callType = '';
  static late int callerCallLogId;
  static late int memberCallLogId;
  static late double memberCallCharge ;
  static late double userCallCharge ;
  static bool isCallConnected = false;
}
