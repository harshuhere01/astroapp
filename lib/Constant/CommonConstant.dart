import 'package:socket_io_client/socket_io_client.dart';

class CommonConstants{
  static double device_width=0;
  static double device_height=0;
  static Socket socket = io('http://34.205.139.16:8085', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  static String CallDone='';

}