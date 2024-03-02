import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import 'package:st_club/presentation/pages/add_post_page.dart';
import '../../constants.dart';
import '../../icon_broken.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "Home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context)..getUserData(userConstFb!.uid)..getPosts();
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (BuildContext context, LoginStates states) {
        if (states is AddPostState) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const AddPostPage();
          }));
        }
        if(states is GetAllUsersLoading){
          cubit.getAllUsers();
        }
      },
      builder: (BuildContext context, LoginStates states) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            actions: [
              IconButton(
                icon: const Icon(IconBroken.Notification, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  IconBroken.Search,
                  color: Colors.black,
                ),
                onPressed: () {},
              )
            ],
          ),
          body: cubit.pages[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.changeNavBar(index);
              },
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    IconBroken.Home,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat),
                  label: "Chat",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.Paper_Upload),
                  label: "Post",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.User),
                  label: "Users",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting),
                  label: "Settings",
                )
              ]),
        );
      },
    );
  }
}
