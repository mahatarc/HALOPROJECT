import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/model/usermodel.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/home.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/login_page.dart';
import 'package:flutterproject/features/authentication/presentation/UI/widgets/formcontainer.dart';
import 'package:flutterproject/features/home/presentation/bloc/home_bloc.dart';

class SignUppage extends StatefulWidget {
  const SignUppage({super.key});
  @override
  State<SignUppage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUppage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();

  late SignUpBloc signUpBloc;
  void initState() {
    signUpBloc = BlocProvider.of<SignUpBloc>(context);
    signUpBloc.add(SignUpInitialEvent());

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
        bloc: signUpBloc,
        listenWhen: (previous, current) => current is SignUpActionState,
        buildWhen: (previous, current) => current is! SignUpActionState,
        builder: (context, state) {
          if (state is SignUpInitialState) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset('images/logo.png', width: 150, height: 150),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 450,
                          width: 325,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Please Sign Up To Your Account',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Formcontainerwidget(
                                controller: _nameController,
                                hinttext: "Name",
                                isPasswordField: false,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Formcontainerwidget(
                                controller: _phoneNoController,
                                hinttext: "Phone Number",
                                isPasswordField: false,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Formcontainerwidget(
                                controller: _emailController,
                                hinttext: "Email Address",
                                isPasswordField: false,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Formcontainerwidget(
                                controller: _passwordController,
                                hinttext: "Password",
                                isPasswordField: true,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  signUpBloc.add(SignUpButtonPressedEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      user: UserModel(
                                        email: _emailController.text,
                                        name: _nameController.text,
                                        role: 'buyer',
                                      )));
                                },
                                child: Container(
                                  // width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 156, 199, 107),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text("Sign Up",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account?"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      signUpBloc.add(LoginButtonPressedEvent());
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 156, 199, 107),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            );
          } else if (state is SignUpErrorState) {
            return const Scaffold();
          } else {
            return const Scaffold();
          }
        },
        listener: (context, state) {
          if (state is LoginPressedNavigateToLoginActionState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => SignInBloc(),
                          child: LoginPage(),
                        )));
          } else if (state is SignUpNavigateToHomePageActionState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => HomePageBloc(),
                          child: Homepage(),
                        )));
          }
        });
  }
}
