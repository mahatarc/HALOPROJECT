import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/firebaseauth/firebaseauth.dart';
import 'package:flutterproject/features/userauth/presenation/pages/homepage/home.dart';
import 'package:flutterproject/features/userauth/presenation/pages/login_page.dart';
import 'package:flutterproject/features/userauth/presenation/widgets/formcontainer.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUppage extends StatefulWidget {
  const SignUppage({super.key});
  @override
  State<SignUppage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUppage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // var width2 = 10;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          /*decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color(0xFFCCFF90),
                Color(0xFFB2FF59),
                Color(0xFF4CAF50),
              ])),*/
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 10,
            ),
            Image.asset('images/logo.png', width: 150, height: 150),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 650,
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
                    'Namaste !!',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  /* Text(
                    'Please Sign Up To Your Account',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 160,
                        child: Formcontainerwidget(
                          controller: _firstnameController,
                          hinttext: "First Name",
                          // width: 100,

                          isPasswordField: false,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Container(
                        width: 160,
                        child: Formcontainerwidget(
                          controller: _lastnameController,
                          hinttext: "Last Name",
                          isPasswordField: false,
                        ),
                      ),
                    ],
                  ),
                  /* Formcontainerwidget(
                    controller: _firstnameController,
                    hinttext: "First Name",
                    isPasswordField: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Formcontainerwidget(
                    controller: _lastnameController,
                    hinttext: "Last Name",
                    isPasswordField: false,
                  ),*/
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
                    hinttext: "Phone Number",
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
                    onTap: _signUp,
                    child: Container(
                      // width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 156, 199, 107),
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
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      launch(
                          'https://www.facebook.com'); // Replace with your URL
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
                              Text("SIGNUP WITH FACEBOOK",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 156, 199, 107),
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
  }

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signupwithEmailandPassword(email, password);
    if (user != null) {
      debugPrint("Process Successful");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      debugPrint("Error, Try again!!");
    }
  }
}
