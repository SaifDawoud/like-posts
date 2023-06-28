class MyComment {
  late final String? userName;
  late final String? userId;
  late final String? userProfileImage;
  late final String? commentText;

  MyComment({
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.commentText
  });

  MyComment.fromJson(Map<String, dynamic> json) {
    userName = json['name'];
    userId = json['id'];
    userProfileImage = json['userProfileImage'];
    commentText=json['commentText'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'name': userName,
      'userProfileImage': userProfileImage,
      'commentText': commentText,

    };
  }
}
