import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CommonConstants{
  static double device_width=0;
  static double device_height=0;
  static String MobileTokenNotifiaction='';
  static Socket socket = io('http://34.205.139.16:8081', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  static var socketID = '';
  static String CallDone='';
  static bool caller=false;

}