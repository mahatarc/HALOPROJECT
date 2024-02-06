//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
//import 'package:flutterproject/features/userauth/firebaseauth/firebaseauth.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/home.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/login_page.dart';
import 'package:flutterproject/features/authentication/presentation/UI/widgets/formcontainer.dart';

class SignUppage extends StatefulWidget {
  const SignUppage({super.key});
  @override
  State<SignUppage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUppage> {
  // final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late SignUpBloc signUpBloc;
  void initState() {
    signUpBloc = BlocProvider.of<SignUpBloc>(context);
    signUpBloc.add(SignUpInitialEvent());

    super.initState();
  }

  @override
  void dispose() {
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
                          height: 400,
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
                                controller: _emailController,
                                hinttext: "Email Address",
                                isPasswordField: false,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Formcontainerwidget(
                                controller: _passwordController,
                                hinttext: "Password",
                                isPasswordField: true,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {signUpBloc.add(SignUpButtonPressedEvent(email:_emailController.text, password: _passwordController.text));},
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
                context, MaterialPageRoute(builder: (context) => Homepage()));
          }
        });
  }
}
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
         
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//             SizedBox(
//               height: 10,
//             ),
//             Image.asset('images/logo.png', width: 150, height: 150),
//             SizedBox(
//               height: 5,
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Container(
//               height: 400,
//               width: 325,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'Namaste !!',
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'Please Sign Up To Your Account',
//                     style: TextStyle(fontSize: 15, color: Colors.grey),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Formcontainerwidget(
//                     controller: _emailController,
//                     hinttext: "Email Address",
//                     isPasswordField: false,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Formcontainerwidget(
//                     controller: _passwordController,
//                     hinttext: "Password",
//                     isPasswordField: true,
//                   ),
                
//                   SizedBox(
//                     height: 30,
//                   ),
//                   GestureDetector(
//                     onTap: _signUp,
//                     child: Container(
//                       // width: 100,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 156, 199, 107),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(
//                         child: Text("Sign Up",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20)),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Already have an account?"),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginPage()),
//                           );
//                         },
//                         child: Text(
//                           'Login',
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 156, 199, 107),
//                               fontWeight: FontWeight.bold),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ]),
//         ),
//       ),
//     );
//   }

//   void _signUp() async {
//     String email = _emailController.text;
//     String password = _passwordController.text;

//     User? user = await _auth.signupwithEmailandPassword(email, password);
//     if (user != null) {
//       debugPrint("Process Successful");
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => Homepage()));
//     } else {
//       debugPrint("Error, Try again!!");
//     }
//   }
// }
