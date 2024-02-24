import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import 'package:st_club/presentation/screens/register_screen.dart';
import '../screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "Login_screen";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    LoginCubit cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {

          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            title: const Text("ST_Club"),
          ),
          body:cubit.isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            child: Form(
              key: formKey,
              child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 10),
                              child: const Text('Login',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(height: 60),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  validator: (val) {
                                    if (val == null) {
                                      return "Email Must not Be Empty";
                                    } else if (!val.contains("@")) {
                                      return "Type A Valid Email";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(

                                      hintText: "Enter Your Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  validator: (val) {
                                    if (val == null) {
                                      return "password Must not Be Empty";
                                    } else if (val.length < 8) {
                                      return "Try Something Longer";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Enter Your password",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  controller: passwordController,
                                  obscureText: true,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.signIN(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  child: const Text("Login")),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              const Text("New to ST_Club!"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        RegisterScreen.routeName);
                                  },
                                  child: const Text("Register")),
                            ],
                          )
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
