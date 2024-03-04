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

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: cubit.messageStream(userId),
              builder: (context, snapshot) {


                if (snapshot.hasData) {
                  final messagesList = snapshot.data!.docs.reversed
                      as Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>;

                  for (var message in messagesList) {
                    cubit.messagesModelList.add(Message.fromJson(message.data()));
                  }
                }
                return Expanded(
                  child: ListView.builder(
                      reverse: true,
                      itemBuilder: (context, index) {
                        return MessageBubble(message: cubit.messagesModelList[index]);
                      },
                      itemCount: cubit.messagesModelList.length),
                );
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
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
                    controller: cubit.messageController,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      cubit.sendMessage(userId);
                      cubit.messageController.clear();
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
