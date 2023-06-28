import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:st_club/cubits/app_cubit/app_cubit.dart';
import 'package:st_club/cubits/app_cubit/app_states.dart';
import 'package:st_club/presentation/pages/add_post_page.dart';
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
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (BuildContext context, AppCubitStates states) {
        if (states is AddPostState) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const AddPostPage();
          }));
        }
      },
      builder: (BuildContext context, AppCubitStates states) {
        AppCubit cubit = AppCubit.get(context);
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
                  label: "User",
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
