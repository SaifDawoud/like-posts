import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import '../../cubits/login_cubit/login_states.dart';
import '../../presentation/widgets/post.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                child: Image.network(
                  "https://cdn.dribbble.com/users/56251/screenshots/14696619/media/0b2a6cada922652e64fab0f07dadd3f9.png?compress=1&resize=800x600",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => Post(
                    postModel: cubit.posts![index],
                    postId: cubit.postsId![index],
                    likesNo: cubit.postsLikes![index],
                    commentsNo: cubit.postsCommentsNo![index]),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: cubit.posts!.length,
                physics: const BouncingScrollPhysics(),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        );
      },
    );
  }
}
