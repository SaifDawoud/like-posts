import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import 'package:st_club/models/comment_model.dart';

class Comment extends StatelessWidget {
  final MyComment? commentModel;
  final String? commentId;


  Comment({
    this.commentId,
    this.commentModel,


    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit,LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {

          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 10,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  "${commentModel!.userProfileImage}")),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${commentModel!.userName}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.lightBlue,
                                      size: 18,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),

                              ],
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.more_horiz_rounded),
                              onPressed: () {})
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      "${commentModel!.commentText}",
                      style: const TextStyle(

                          fontSize: 14),
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }
}
