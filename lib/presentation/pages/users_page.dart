import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/login_cubit/login_cubit.dart';
import '../../cubits/login_cubit/login_states.dart';
import '../widgets/UsersCard.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    UsersCard(user: cubit.allUsers[index]),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: cubit.allUsers.length,
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
