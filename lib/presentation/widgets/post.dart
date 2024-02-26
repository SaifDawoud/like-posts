import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import 'package:st_club/presentation/pages/comments_page.dart';

import '../../icon_broken.dart';
import '../../models/post_model.dart';

class Post extends StatelessWidget {
  final MyPost? postModel;

  //final String? postId;
  //final int? likesNo;
  // final int? commentsNo;

  Post({
    this.postModel,
    //this.postId,
    //this.likesNo,
    //this.commentsNo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
      if (state is AddCommentPageState) {
        cubit.getComments(post:postModel);
      }
    }, builder: (context, state) {
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
                          backgroundImage:
                              NetworkImage("${postModel!.userProfileImage}")),
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
                                  "${postModel!.userName}",
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
                            Text("${postModel!.dateTime}",
                                style: Theme.of(context).textTheme.bodySmall),
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
                // Container(
                //   height: 1,
                //   color: Colors.grey,
                // ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: postModel!.postImage == null
                      ? const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 30)
                      : const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    "${postModel!.postText}",
                    textAlign: TextAlign.start,
                  ),
                ),
                // Container(
                //   padding :const EdgeInsets.symmetric(horizontal:8.0),
                //   width: double.infinity,
                //   child: Wrap( alignment: WrapAlignment.start,
                //     children: [
                //       MaterialButton(
                //         height: 25,minWidth: 1,
                //         padding: EdgeInsets.zero,
                //         child:const Text("#SoftWare",style: TextStyle(color:Colors.lightBlue ),),
                //         onPressed: () {},
                //       ),
                //       MaterialButton(
                //         height: 25,minWidth: 1,
                //         padding: EdgeInsets.zero,
                //         child:const Text("#Flutter",style: TextStyle(color:Colors.lightBlue ),),
                //         onPressed: () {},
                //       ),
                //       MaterialButton(
                //         height: 25,minWidth: 1,
                //         padding: EdgeInsets.zero,
                //         child:const Text("#Flutter",style: TextStyle(color:Colors.lightBlue ),),
                //         onPressed: () {},
                //       ),
                //     ],
                //   ),
                // ),

                postModel!.postImage == null
                    ? const SizedBox(
                        height: 15,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image:
                                      NetworkImage("${postModel!.postImage}"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              //check if liked
                              cubit.checkIfLiked(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      postModel)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.redAccent,
                                    )
                                  : const Icon(
                                      IconBroken.Heart,
                                      color: Colors.redAccent,
                                    ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("${postModel!.postLikes!.length}")
                            ],
                          )),
                      const Spacer(),
                      InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              const Icon(
                                IconBroken.Chat,
                                color: Colors.yellow,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              //${postModel!.postComments}
                              Text("${postModel!.postComments}")
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              "${cubit.userModel!.userProfileImage}")),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          cubit.getComments(post: postModel);
                          //state = AddCommentPageState();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return CommentsPage(post: postModel);
                          }));
                        },
                        child: Text('Write a Comment...'),
                      )),
                      InkWell(
                        onTap: () {
                          cubit.likePost(postModel);
                        },
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text("Like")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
