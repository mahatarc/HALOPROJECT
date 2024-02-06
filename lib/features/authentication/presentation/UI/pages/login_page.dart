import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/home.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/sign_up_page.dart';
import 'package:flutterproject/features/authentication/presentation/UI/widgets/formcontainer.dart';
//import 'package:flutterproject/features/userauth/firebaseauth/firebaseauth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SignInBloc signInBloc;
  @override
  void initState() {
    signInBloc = BlocProvider.of<SignInBloc>(context);
    signInBloc.add(SignInInitialEvent());

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInStates>(
        bloc: signInBloc,
        listenWhen: (previous, current) => current is SignInActionState,
        buildWhen: (previous, current) => current is! SignInActionState,
        builder: (context, state) {
          if (state is SignInInitialState) {
            return Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset('images/logo.png', width: 150, height: 150),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 300,
                          width: 325,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Formcontainerwidget(
                                controller: _emailController,
                                hinttext: "Email Address",
                                isPasswordField: false,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Formcontainerwidget(
                                controller: _passwordController,
                                hinttext: "Password",
                                isPasswordField: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  signInBloc.add(SignInButtonPressedEvent(email: _emailController.text, password: _passwordController.text));
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 156, 199, 107),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text("Login",
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
                                  const Text("Don't have an account?"),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      signInBloc.add(
                                          SignUpButtonPressedNavigateEvent());
                                    },
                                    child: const Text(
                                      'Sign Up',
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
          } else if (state is SignInErrorState) {
            return const Scaffold();
          } else {
            return const Scaffold();
          }
        },
        listener: (context, state) {
          if (state is SignUpPressedNavigateToSignUpActionState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => SignUpBloc(),
                          child: SignUppage(),
                        )));
          } else if (state is SignInNavigateToHomePageActionState) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homepage()));
          }
        });
  }
}

  
