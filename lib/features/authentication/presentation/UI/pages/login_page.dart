import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/forgot_bloc/forgot_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/home.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/sign_up_page.dart';
import 'package:flutterproject/features/authentication/presentation/UI/widgets/formcontainer.dart';
import 'package:flutterproject/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/seller.dart';
import 'package:flutterproject/forgot.dart/forgot_pass_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              body: Stack(
                children: [
                  const Image(
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    image: AssetImage('images/aaa.jpg'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          const Color.fromARGB(255, 51, 76, 56),
                          Colors.black.withOpacity(0.15)
                        ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('images/logo.png',
                                width: 200, height: 220),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Namaste !!',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 248, 249, 247),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              // padding: const EdgeInsets.all(16),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                              child: Formcontainerwidget(
                                controller: _emailController,
                                hinttext: "Email Address",
                                isPasswordField: false,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            Padding(
                              // padding: const EdgeInsets.all(16),
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                              child: Formcontainerwidget(
                                controller: _passwordController,
                                hinttext: "Password",
                                isPasswordField: true,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: () {
                                  signInBloc.add(SignInButtonPressedEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text));
                                },
                                child: ElevatedButton(
                                  onPressed: () {
                                    signInBloc.add(SignInButtonPressedEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 156, 199, 107),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  ForgotPasswordBloc(),
                                              child:
                                                  const ForgotPasswordScreen(),
                                            )));
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 156, 199, 107),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 248, 249, 247),
                                      fontWeight: FontWeight.bold),
                                ),
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
                                        color:
                                            Color.fromARGB(255, 156, 199, 107),
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is SignInErrorState) {
            return const Scaffold();
          } else if (state is SignInNavigateToBuyerHomePageActionState) {
            return const Homepage();
          } else if (state is SignInNavigateToSellerHomePageActionState) {
            return SellerDashboard();
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
                          child: const SignUppage(),
                        )));
          } else if (state is SignInNavigateToBuyerHomePageActionState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => HomePageBloc(),
                          child: const Homepage(),
                        )));
          } else if (state is SignInNavigateToSellerHomePageActionState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SellerDashboard()),
            );
          }
        });
  }
}
