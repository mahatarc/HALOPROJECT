import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/app/splash_screen/splash.dart';
import 'package:flutterproject/features/userauth/presenation/pages/homepage/home.dart';
import 'package:flutterproject/features/userauth/presenation/pages/login_page.dart';
import 'package:flutterproject/features/userauth/presenation/pages/sign_up.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    theme: ThemeData(
      primarySwatch: Colors.lightGreen,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => const SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUppage(),
        '/home': (context) => Homepage(),
      },
    );
  }
}
