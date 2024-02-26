class MyPost {
  late final String? userName;
  late final String? userId;
  late final String? postId;
  late final String? userProfileImage;
  late final String? postText;
  late final String? postImage;
  late final String? dateTime;
  late List<dynamic>? postLikes ;
  //late Map<String, dynamic>? postComments = {};
  late int postComments ;

  MyPost(
      {required this.userId,
      required this.userName,
      this.postId,
      required this.userProfileImage,
      required this.postText,
      required this.dateTime,
      this.postLikes,
      this.postImage,
      required this.postComments});

  MyPost.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    postLikes = json['postLikes'];
    postComments = json['postComments'];
    postId = json['postId'];
    postImage = json['postImage'];
    postText = json['postText'];
    userId = json['userId'];
    userProfileImage = json['userProfileImage'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'postLikes': postLikes,
      'postComments': postComments,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'postText': postText,
      'postImage': postImage,
      'dateTime': dateTime,
    };
  }
}
