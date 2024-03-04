import 'message_model.dart';

class MyUser {
  late final String userName;
  late final String? userEmail;
  late final String? userId;
  late final String? userImage;
  late final String? userProfileImage;
  late final String? bio;
  late final Message? lastMessage;

  MyUser(
      {required this.userEmail,
      required this.userId,
      required this.userName,
      required this.bio,
      required this.userProfileImage,
      required this.userImage});

  MyUser.fromJson(Map<String, dynamic> json) {
    userName = json['name'];
    lastMessage = Message.fromJson(json['lastMessage']);
    bio = json['bio'];
    userId = json['id'];
    userEmail = json['email'];
    userImage = json['userImage'];
    userProfileImage = json['userProfileImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'lastMessage': lastMessage!.toMap(),
      'bio': bio,
      'name': userName,
      'email': userEmail,
      'userImage': userImage,
      'userProfileImage': userProfileImage,
    };
  }
}
