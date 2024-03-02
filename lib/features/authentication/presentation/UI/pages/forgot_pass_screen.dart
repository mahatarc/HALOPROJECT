import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/reset_password.dart';
import 'package:flutterproject/features/authentication/presentation/UI/widgets/formcontainer.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<bool> checkEmailExists(String email) async {
    try {
      // Query the user collection in Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Check if any documents match the query
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle errors
      print('Error checking email existence: $e');
      return false; // Return false for any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Formcontainerwidget(
                controller: _emailController,
                hinttext: "Email Address",
                isPasswordField: false,
                borderRadius: 10.0,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                bool emailExists = await checkEmailExists(email);
                if (emailExists) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(email: email),
                    ),
                  );
                } else {
                  // Show an error message or dialog indicating that the email does not exist
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Email address does not exist.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
