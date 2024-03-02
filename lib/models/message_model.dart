import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message {
  late final String? messageText;
  late final String? sender;
  late final Timestamp? sentAt;

  Message({
    required this.messageText,
    required this.sender,
    required this.sentAt,
  });

  Message.fromJson(Map<String, dynamic> json) {
    messageText = json['messageText'];
    sender = json['sender'];
    sentAt = json['sentAt'] ;
  }

  bool get isMine => sender==FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic> toMap() {
    return {
      'messageText': messageText,
      'sender': sender,
      'sentAt': sentAt,
    };
  }
}
