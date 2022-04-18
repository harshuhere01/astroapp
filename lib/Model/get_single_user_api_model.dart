class GetSingleUserDetailsModel {
  String? message;
  Data? data;

  GetSingleUserDetailsModel({this.message, this.data});

  GetSingleUserDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? age;
  String? sex;
  String? mobile;
  String? photo;
  String? available;
  String? fcmToken;
  bool? isMemberRequested;
  bool? isMember;
  bool? isActive;
  String? callRate;
  String? socialMediaLink;
  String? aboutMe;
  String? achievements;
  String? status;
  String? languages;
  String? experience;
  String? totalChatMinute;
  String? totalCallMinute;

  Data(
      {this.id,
        this.name,
        this.email,
        this.age,
        this.sex,
        this.mobile,
        this.photo,
        this.available,
        this.fcmToken,
        this.isMemberRequested,
        this.isMember,
        this.isActive,
        this.callRate,
        this.socialMediaLink,
        this.aboutMe,
        this.achievements,
        this.status,
        this.languages,
        this.experience,
        this.totalChatMinute,
        this.totalCallMinute});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    age = json['age'];
    sex = json['sex'];
    mobile = json['mobile'];
    photo = json['photo'];
    available = json['available'];
    fcmToken = json['fcm_token'];
    isMemberRequested = json['isMemberRequested'];
    isMember = json['isMember'];
    isActive = json['isActive'];
    callRate = json['call_rate'];
    socialMediaLink = json['social_media_link'];
    aboutMe = json['about_me'];
    achievements = json['achievements'];
    status = json['status'];
    languages = json['languages'];
    experience = json['experience'];
    totalChatMinute = json['total_chat_minute'];
    totalCallMinute = json['total_call_minute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['age'] = age;
    data['sex'] = sex;
    data['mobile'] = mobile;
    data['photo'] = photo;
    data['available'] = available;
    data['fcm_token'] = fcmToken;
    data['isMemberRequested'] = isMemberRequested;
    data['isMember'] = isMember;
    data['isActive'] = isActive;
    data['call_rate'] = callRate;
    data['social_media_link'] = socialMediaLink;
    data['about_me'] = aboutMe;
    data['achievements'] = achievements;
    data['status'] = status;
    data['languages'] = languages;
    data['experience'] = experience;
    data['total_chat_minute'] = totalChatMinute;
    data['total_call_minute'] = totalCallMinute;
    return data;
  }
}
