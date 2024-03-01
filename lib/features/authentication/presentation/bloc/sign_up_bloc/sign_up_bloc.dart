import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/model/usermodel.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpInitialEvent>(signUpInitialEvent);
    on<SignUpButtonPressedEvent>(signUpButtonPressedEvent);
    on<LoginButtonPressedEvent>(loginButtonPressedEvent);
  }

  FutureOr<void> signUpInitialEvent(
      SignUpInitialEvent event, Emitter<SignUpState> emit) {
    emit(SignUpInitialState());
  }

  FutureOr<void> signUpButtonPressedEvent(
      SignUpButtonPressedEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(SignUpLoadingState());
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
//       // Get the current user
//       User? user = FirebaseAuth.instance.currentUser;

// // Check if user is signed in
//       if (user != null && !user.emailVerified) {
//         // Send verification email
//         await user.sendEmailVerification();
//       }

//       emit(VerificationEmailSentState(event.email));

//       const timeoutDuration = Duration(minutes: 1); // Example: 1 minute
//       final startTime = DateTime.now();

// // Wait for email verification or until timeout
//       while (DateTime.now().difference(startTime) < timeoutDuration) {
//         // Reload user to check if email is verified
//         await credential.user!.reload();

//         // Check email verification status after reloading
//         if (credential.user!.emailVerified) {
//           emit(EmailVerifiedState());
//           print('Email verified');
//           addUserDetails(credential.user!.uid, event.user);
//           return; // Exit the while loop if email is verified
//         }

//         // Add a short delay before checking again
//         await Future.delayed(Duration(seconds: 5));
//       }

// // If the loop completes without email verification, handle the timeout
//       print('Email verification timeout');
//final FirebaseUser user = mAuth.getCurrentUser();
      // Send verification email
      // Send verification email
      await credential.user!.sendEmailVerification();

      emit(VerificationEmailSentState(event.email));

      // Wait for email verification
      final user = await FirebaseAuth.instance.authStateChanges().firstWhere(
          (user) => user!.uid == credential.user!.uid && user.emailVerified);

      // Update UI with user's email and verification status
      String statusText =
          "${user!.email} - ${user.emailVerified ? 'Verified' : 'Not Verified'}";
      emit(StatusTextChangedState(statusText));
      print(statusText);
      addUserDetails(credential.user!.uid, event.user);
      emit(EmailVerifiedState());
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  FutureOr<void> loginButtonPressedEvent(
      LoginButtonPressedEvent event, Emitter<SignUpState> emit) {
    emit(LoginPressedNavigateToLoginActionState());
  }
}

Future addUserDetails(String uid, UserModel user) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .set(user.toJson());
}
