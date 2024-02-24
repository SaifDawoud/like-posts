import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import 'package:st_club/icon_broken.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context);
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: const Text("Create Post",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(IconBroken.Arrow___Left_2),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  cubit.createPost(postText: postTextController.text);
                },
                child:  Text(
                  "Post",
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                )),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is CreatePostSuccessState) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (state is UploadPostImageLoadingState)
                  const LinearProgressIndicator(minHeight: 6),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              "${cubit.userModel!.userProfileImage}")),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "${cubit.userModel!.userName}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: postTextController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: InputBorder.none,

                      hintText: "Write What is On Your Mind...",
                    ),
                  ),
                ),
                cubit.postImage == null
                    ? Expanded(
                        child: Container(),
                      )
                    : Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: FileImage(cubit.postImage!),
                                      fit: BoxFit.cover)),
                            ),
                            Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: IconButton(
                                    onPressed: () {
                                      cubit.removePostImage();
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    )))
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            cubit.pickPostImage();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(IconBroken.Image),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Add Photo")
                            ],
                          )),
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () {}, child: const Text("# Tags")))
                  ],
                )
              ],
            );
          },
        ));
  }
}
