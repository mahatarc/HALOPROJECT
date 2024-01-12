import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/home.dart';
import 'package:flutterproject/features/userauth/presenation/pages/sign_up.dart';
//import 'package:flutterproject/features/userauth/presenation/pages/home_page.dart';
import 'package:flutterproject/features/userauth/presenation/widgets/formcontainer.dart';
import 'package:flutterproject/features/userauth/firebaseauth/firebaseauth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          /*  decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
              colors: [
                Color(0xFFCCFF90),
                Color(0xFFB2FF59),
                Color(0xFF4CAF50),
              ]
          )),*/
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset('images/logo.png', width: 100, height: 100),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 350,
              width: 325,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Namaste !!',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Please Login To Your Account',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
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
                  /*  Formcontainerwidget(
                    controller: _passwordController,
                    hinttext: "Phone Number",
                    isPasswordField: false,
                  ),*/
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: _signin,
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Homepage()));
                    //  }
                    child: Container(
                      // width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 156, 199, 107),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUppage(),
                              ));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
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
  }

  void _signin() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signInwithEmailandPassword(email, password);
    if (user != null) {
      debugPrint("Process Successful");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      debugPrint("Error, Try again!!");
    }
  }
}
