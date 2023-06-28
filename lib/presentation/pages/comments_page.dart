import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/presentation/widgets/comment.dart';
import '../../cubits/login_cubit/login_states.dart';
import '../../icon_broken.dart';
import '../../presentation/widgets/post.dart';

class CommentsPage extends StatelessWidget {
  final String? postId;
  TextEditingController commentController = TextEditingController();

  CommentsPage({super.key, this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
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
                                postId: postId,
                                comment: commentController.text);
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
