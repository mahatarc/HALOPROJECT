// forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/forgot_bloc/forgot_bloc.dart';

import 'package:flutterproject/forgot.dart/forgot_pass_screen.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: BlocProvider(
        create: (context) => ForgotPasswordBloc(),
        child: ForgotPasswordScreen(),
      ),
    );
  }
}
