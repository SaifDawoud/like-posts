import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_club/cache_helper.dart';
import 'package:st_club/cubits/app_cubit/app_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/presentation/screens/register_screen.dart';
import './presentation/screens/home_screen.dart';
import './presentation/screens/login_screen.dart';
import './observer.dart';
import './constraints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  userConstFb = FirebaseAuth.instance.currentUser;
  Bloc.observer = MyBlocObserver();
  uId = CacheHelper.getData(key: 'uId');
  Widget widget;
  if (uId != null) {
    widget = const HomeScreen();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    staringWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.staringWidget});

  final Widget staringWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(create: (BuildContext context) => AppCubit()),
        BlocProvider<LoginCubit>(create: (BuildContext context) {
          if (uId == null) {
            return LoginCubit()..getPosts()..getComments();
          }else{
            return LoginCubit()..getUserData(uId)..getPosts();
          }
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ST_Club',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        home: staringWidget,
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
          LoginScreen.routeName: (_) => LoginScreen(),
          RegisterScreen.routeName: (_) => RegisterScreen(),
        },
      ),
    );
  }
}
