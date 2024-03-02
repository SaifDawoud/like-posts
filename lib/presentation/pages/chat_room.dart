import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/presentation/widgets/message_bubble.dart';

import '../../icon_broken.dart';
import '../../models/message_model.dart';

class ChatRoom extends StatelessWidget {
  String? userId;

  ChatRoom({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context);

    TextEditingController messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(cubit.userModel!.userId)
                  .collection("messages")
                  .doc(userId)
                  .collection("messages")
                  .orderBy("sentAt")
                  .snapshots()
              ,
              builder: (context, snapshot) {
                final messagesModellist = [];

                if (snapshot.hasData) {
                  final messageslist = snapshot.data!.docs.reversed
                      as Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>;

                  for (var message in messageslist) {
                    messagesModellist.add(Message.fromJson(message.data()));
                  }


                }
                return Expanded(
                  child: ListView.builder(
                      reverse: true,
                      itemBuilder: (context, index) {
                        return MessageBubble(message: messagesModellist[index]);
                      },
                      itemCount: messagesModellist.length),
                );
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    validator: (val) {
                      if (val == null) {
                        return "Message Must not Be Empty";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Type A Message...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: messageController,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Message tobeSentMessage = Message(
                          messageText: messageController.text,
                          sender: cubit.userModel!.userId,
                          sentAt: Timestamp.now());

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(cubit.userModel!.userId)
                          .collection("messages")
                          .doc(userId).collection("messages")
                          .add(tobeSentMessage.toMap());
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(userId)
                          .collection("messages")
                          .doc(cubit.userModel!.userId).collection("messages")
                          .add(tobeSentMessage.toMap());
                      messageController.clear();
                    },
                    icon: const Icon(IconBroken.Send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
