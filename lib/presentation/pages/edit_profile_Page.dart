import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import 'package:st_club/icon_broken.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context);
    nameController.text = cubit.userModel!.userName!;
    bioController.text = cubit.userModel!.bio!;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Edit Profile",
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
                cubit.updateUerDate(
                    bio: bioController.text,
                    userName: nameController.text,

                    );
              },
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.blueAccent, fontSize: 20),
              )),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if(state is UpdateUserDataSuccessState){

            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              if (cubit.isUploading||cubit.isUpdateing)
                const LinearProgressIndicator(minHeight: 6),

              Container(
                height: 210,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: cubit.coverImage == null
                                      ? NetworkImage(
                                          "${cubit.userModel!.userImage}",
                                        )
                                      : FileImage(cubit.coverImage!)
                                          as ImageProvider,
                                ),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: cubit.coverImage == null
                                  ? IconButton(
                                      onPressed: () {
                                        cubit.pickCoverImage();
                                      },
                                      icon: const Icon(IconBroken.Camera),
                                      color: Colors.white,
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        cubit.uploadCoverImage();
                                      },
                                      icon: const Icon(IconBroken.Upload),
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 63,
                      child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: cubit.profileImage == null
                                  ? NetworkImage(
                                      "${cubit.userModel!.userProfileImage}")
                                  : FileImage(cubit.profileImage!)
                                      as ImageProvider,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: cubit.profileImage == null
                                  ? IconButton(
                                      onPressed: () {
                                        cubit.pickProfileImage();
                                      },
                                      icon: const Icon(IconBroken.Camera),
                                      color: Colors.white,
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        cubit.uploadProfileImage();
                                      },
                                      icon: const Icon(IconBroken.Upload),
                                      color: Colors.white,
                                    ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      label: Text("Name"),
                      border: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          )),
                      icon: Icon(IconBroken.User),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      label: Text("Bio..."),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          )),
                      icon: Icon(IconBroken.Edit_Square),
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}
