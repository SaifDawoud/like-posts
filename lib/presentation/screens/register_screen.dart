import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_club/cubits/login_cubit/login_cubit.dart';
import 'package:st_club/cubits/login_cubit/login_states.dart';
import '../screens/home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName="Register_screen";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    LoginCubit cubit=LoginCubit.get(context);
    return BlocConsumer<LoginCubit,LoginStates>(
      listener: (context, state) {
        if(state is CreateUserSuccessState){
          Navigator.of(context)
              .pushReplacementNamed(HomeScreen.routeName);

        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            title: const Text("ST_Club"),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    Container(
                        margin:const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                        child: const Text('Register',
                            style: TextStyle(

                                fontSize: 18, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 60),
                    Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
                      Container(
                        margin:const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black ),
                          validator: (val) {
                            if (val == null) {
                              return "Name Must not Be Empty";
                            }
                            else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Enter your Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          controller: nameController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Container(
                        margin:const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black ),
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
                                  borderRadius: BorderRadius.circular(15))),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin:const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black ),
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
                                  borderRadius: BorderRadius.circular(15))),
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
                              cubit.register(name: nameController.text,email: emailController.text,password: passwordController.text);

                            }
                          },
                          child:const Text("register")),],),
                    const SizedBox(height: 40,),
                    Row(
                      children: [
                        const Text("Already Have an Account!"),
                        TextButton(onPressed: (){
                          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                        }, child:const Text("Login")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );},
    );
  }
}
