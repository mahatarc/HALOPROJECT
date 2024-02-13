import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/forgot_bloc/forgot_bloc.dart';
import 'forgot_pass_screen.dart'; // Import the ForgotPasswordScreen widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot Password Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ForgotPasswordBloc(),
        child:
            ForgotPasswordScreen(), // Use ForgotPasswordScreen as the home screen
      ),
    );
  }
}
