import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import 'package:st_club/presentation/pages/add_post_page.dart';
import 'package:st_club/presentation/widgets/UsersCard.dart';
import '../../constants.dart';
import '../../icon_broken.dart';
import '../../models/my_user.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "Home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context)
      ..getUserData(userConstFb!.uid)
      ..getPosts();
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (BuildContext context, LoginStates states) {
        if (states is AddPostState) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const AddPostPage();
          }));
        }
        if (states is GetAllUsersLoading) {
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
              cubit.currentIndex == 3
                  ? IconButton(
                      icon: const Icon(
                        IconBroken.Search,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate:
                                CustomSearchDelegate(users: cubit.allUsers));
                      },
                    )
                  : Container()
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
                  label: "Chats",
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

class CustomSearchDelegate extends SearchDelegate {
  late List<MyUser> users = [];

  CustomSearchDelegate({required this.users});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<MyUser> matchQuery = [];
    for (var user in users) {
      if (user.userName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(user);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return UsersCard(
          user: result,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchQuery = [];
    for (var user in users) {
      if (user.userName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(user);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return UsersCard(
          user: result,
        );
      },
    );
  }
}
