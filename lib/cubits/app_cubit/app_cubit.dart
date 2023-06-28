
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_cubit/app_states.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/chat_page.dart';
import '../../presentation/pages/user_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/add_post_page.dart';



class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> pages = [
    HomePage(),
    ChatPage(),
    AddPostPage(),
    UserPage(),
    SettingsPage()
  ];
  List<String> titles = const ["Feed", "Chat", "Add Post", "Users", "Settings"];

  void changeNavBar(int index) {
    if (index == 2) {
      emit(AddPostState());
    } else {
      currentIndex = index;
      emit(ChangeNavBarState());
    }
  }

  // MyUser? user;
  //
  // void getUserData(String id) {
  //   FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
  //     user = MyUser.fromJson(value.data()!);
  //     debugPrint("getuserdata${user!.userEmail}");
  //     debugPrint(user!.userId);
  //
  //   }).catchError((error) {
  //     debugPrint(error.toString());
  //   });
  // }

}
