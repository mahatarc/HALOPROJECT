import 'package:flutter/material.dart';
import 'package:flutterproject/features/authentication/presentation/UI/widgets/formcontainer.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/seller%20mode/seller.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/seller%20mode/seller_registration.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: Slogin()),
  );
}

class Slogin extends StatefulWidget {
  const Slogin({super.key});

  @override
  State<Slogin> createState() => _SloginState();
}

class _SloginState extends State<Slogin> {
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
      body: Stack(
        children: [
          Image(
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            image: AssetImage('images/aaa.jpg'),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 51, 76, 56),
              Colors.black.withOpacity(0.15)
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/logo.png', width: 200, height: 150),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 10,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Formcontainerwidget(
                    controller: _emailController,
                    hinttext: "Email Address",
                    isPasswordField: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerDashboard(),
                          ));
                    },
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellerRegistrationForm(),
                            ));
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            color: Color.fromARGB(255, 156, 199, 107),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
