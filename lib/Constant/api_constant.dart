class APIConstants {
  // BaseURL_Live = 'http://34.205.139.16:8085/';
  //    BaseURL_Local = 'http://192.168.1.2:8085/';

  static String firebaseNotificationAPI = 'https://fcm.googleapis.com/fcm/send';
  static String baseURL = 'http://34.205.139.16:8081/';
  static String getAllUsers = "user/getAll";
  static String getAllMember = "user/getAllMember";
  static String registerUser = "user/create";
  static String updateUser = "user/update";
  static String updateFCMToken = "user/updateFCMToken";
  static String addMoneyURL = 'payments/add_money';
  static String verifyPaymentURL = 'payments/verify_payment';
  static String getWalletAmountURL = 'wallet/get_balance';
  static String createToken = 'video_chat/join_call';
  static String sendNotification = 'video_chat/send_notification';
  static String calculateTime = 'video_chat/calculate_time';
  static String getBalance = 'payments/get_balance';
  static String startVideoCall = 'video_chat/start_video_call';
  static String getSingelUser = 'user/getById';
}
