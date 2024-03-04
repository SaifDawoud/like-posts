import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import 'package:st_club/models/my_user.dart';
import 'package:st_club/presentation/pages/chat_room.dart';

import '../../models/message_model.dart';

class ChatRoomCard extends StatelessWidget {
  MyUser? user;

  ChatRoomCard({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatRoom(
                  userId: user!.userId,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage("${user!.userProfileImage}")),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user!.userName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "${user!.lastMessage!.messageText}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(DateFormat()
                    .add_MMMEd()
                    .format(user!.lastMessage!.sentAt!.toDate()),
          style: const TextStyle(fontSize: 12, color: Colors.grey)
                ),
                Text(DateFormat()
                    .add_jm()
                    .format(user!.lastMessage!.sentAt!.toDate()),
                    style: const TextStyle(fontSize: 12, color: Colors.grey)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
