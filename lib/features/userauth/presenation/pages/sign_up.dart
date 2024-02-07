import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/firebaseauth/firebaseauth.dart';
import 'package:flutterproject/features/userauth/presenation/pages/homepage/home.dart';
import 'package:flutterproject/features/userauth/presenation/pages/login_page.dart';
import 'package:flutterproject/features/userauth/presenation/widgets/formcontainer.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUppage extends StatefulWidget {
  const SignUppage({Key? key}) : super(key: key);

  @override
  State<SignUppage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUppage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Image.asset('images/logo.png', width: 150, height: 150),
              SizedBox(height: 10),
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
                    SizedBox(height: 10),
                    Text(
                      'Namaste !!',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 160,
                          child: Formcontainerwidget(
                            controller: _firstnameController,
                            hinttext: "First Name",
                            isPasswordField: false,
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        SizedBox(width: 2),
                        Container(
                          width: 160,
                          child: Formcontainerwidget(
                            controller: _lastnameController,
                            hinttext: "Last Name",
                            isPasswordField: false,
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Formcontainerwidget(
                      controller: _emailController,
                      hinttext: "Email Address",
                      isPasswordField: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    Formcontainerwidget(
                      controller: _phoneController,
                      hinttext: "Phone Number",
                      isPasswordField: false,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        } else if (value.length != 10) {
                          return 'Phone number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Formcontainerwidget(
                      controller: _passwordController,
                      hinttext: "Password",
                      isPasswordField: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreedToTerms = value ?? false;
                                });
                              },
                            ),
                            SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                "By clicking Sign Up, you agree to our",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // You can replace this URL with your terms of service URL
                            launch('https://www.example.com/terms_of_service');
                          },
                          child: Text(
                            'Terms of Service',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _isLoading
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: _signUp,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 156, 199, 107),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        print('Tapped');
                        launch('https://www.facebook.com');
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
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
                              SizedBox(width: 8.0),
                              Text(
                                "SIGN UP WITH FACEBOOK",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 156, 199, 107),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;
    //String phoneNumber = _phoneController.text;

    // Validate the form
    if (_validateForm()) {
      // Perform sign-up
      User? user = await _auth.signupwithEmailandPassword(email, password);
      if (user != null) {
        debugPrint("Process Successful");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } else {
        debugPrint("Error, Try again!!");
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _validateForm() {
    if (_firstnameController.text.isEmpty ||
        _lastnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields are required.'),
        ),
      );
      return false;
    }

    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number must be 10 digits.'),
        ),
      );
      return false;
    }

    return true;
  }
}
