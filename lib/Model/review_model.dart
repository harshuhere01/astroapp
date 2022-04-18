class RatingAndReview {
  String? name;
  double? rating;
  String? imageUrl;
  String? review;
  String? repliedUserName;
  String? repliedDate;
  String? repliedText;
  bool? isReplied;

  RatingAndReview({this.name, this.rating, this.imageUrl, this.review,this.isReplied,this.repliedDate,this.repliedText,this.repliedUserName});

  RatingAndReview.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rating = json['rating'];
    imageUrl = json['imageUrl'];
    review = json['review'];
    isReplied = json['isReplied'];
    repliedDate = json['repliedDate'];
    repliedText = json['repliedText'];
    repliedUserName = json['repliedUserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['rating'] = rating;
    data['imageUrl'] = imageUrl;
    data['review'] = review;
    data['isReplied'] = isReplied;
    data['repliedDate'] = repliedDate;
    data['repliedText'] = repliedText;
    data['repliedUserName'] = repliedUserName;
    return data;
  }
}
