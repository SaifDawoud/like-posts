import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/models/post_model.dart';
import 'package:st_club/presentation/widgets/comment.dart';
import '../../cubits/login_cubit/login_states.dart';
import '../../icon_broken.dart';


class CommentsPage extends StatelessWidget {
  final MyPost? post;
  TextEditingController commentController = TextEditingController();

  CommentsPage({super.key, this.post});

  @override
  Widget build(BuildContext context) {

    LoginCubit cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            title: const Text("Comments"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Comment(
                    commentModel: cubit.comments![index],
                    commentId: cubit.commentsId![index],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: cubit.comments!.length,
                  physics: const BouncingScrollPhysics(),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: (val) {
                            if (val == null) {
                              return "comment Must not Be Empty";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Type A Comment",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: commentController,

                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            cubit.addComment(
                                post: post,
                                comment: commentController.text);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(IconBroken.Send))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
