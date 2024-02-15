import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/app/splash_screen/splash.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/home.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/login_page.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/sign_up_page.dart';

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: "AIzaSyBdU1t--v-A3JM63PwTiv-O6KEQj1l-N5A",
            appId: "1:498172769727:android:f1966ffb693548d06f9d0a",
            messagingSenderId: "498172769727",
            projectId: "halo-7c6f5",
            storageBucket: "halo-7c6f5.appspot.com",
          ),
        )
      : await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(),
      child: const LoginPage(),
    ),
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
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUppage(),
        '/home': (context) => const LandingPage(),
      },
    );
  }
}
