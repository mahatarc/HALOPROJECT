import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/homepage/home.dart';
import 'package:flutterproject/features/userauth/presenation/pages/sign_up.dart';
import 'package:flutterproject/features/userauth/presenation/widgets/formcontainer.dart';
import 'package:flutterproject/features/userauth/firebaseauth/firebaseauth.dart';
import 'package:url_launcher/url_launcher.dart';

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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset('images/logo.png', width: 150, height: 150),
            // const SizedBox(
            // height: 5,
            // ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 600,
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
                    height: 20,
                  ),
                  Formcontainerwidget(
                    controller: _emailController,
                    hinttext: "Email Address",
                    isPasswordField: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Formcontainerwidget(
                    controller: _passwordController,
                    hinttext: "Password",
                    isPasswordField: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: _signin,
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
                  /*const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 249, 250, 249),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors
                              .black, // You can set the color of the border here
                          width:
                              1.0, // You can set the width of the border here
                        ),
                      ),
                      child: const Center(
                        child: Text("Sign in with Google",
                            // icons: Icons.google,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                    ),
                  ),*/
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      launch('https://www.facebook.com');
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors
                              .black, // You can set the color of the border here
                          width:
                              1.0, // You can set the width of the border here
                        ),
                      ),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.facebook,
                                color: Colors.black,
                              ),
                              SizedBox(
                                  width:
                                      8.0), // Adjust the spacing between icon and text
                              Text("LOGIN WITH FACEBOOK",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                              color: const Color.fromARGB(255, 156, 199, 107),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
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
