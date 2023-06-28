class MyPost {
  late final String? userName;
  late final String? userId;
  late final String? userProfileImage;
  late final String? postText;
  late final String? postImage;
  late final String? dateTime;

  MyPost({
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.postText,
    required this.dateTime,
    this.postImage,
  });

  MyPost.fromJson(Map<String, dynamic> json) {
    userName = json['name'];
    postImage = json['postImage'];
    postText = json['postText'];
    userId = json['id'];
    userProfileImage = json['userProfileImage'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'name': userName,
      'userProfileImage': userProfileImage,
      'postText': postText,
      'postImage': postImage,
      'dateTime': dateTime,
    };
  }
}
