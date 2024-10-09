import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/login_page.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;

  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  Future<void> resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message or navigate to a success screen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Password reset email sent to $email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => SignInBloc(),
                      child: LoginPage(),
                    ),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Show error message if password reset fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to send password reset email.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reset Password for $email',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => resetPassword(context),
              child: Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}
