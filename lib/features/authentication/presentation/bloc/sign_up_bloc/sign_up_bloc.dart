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
      await credential.user!.sendEmailVerification();
      emit(VerificationEmailSentState(event.email, event.user));
      print('User data has been successfully added after email verification');
    } on FirebaseAuthException catch (error) {
      String errorMessage = '';
      if (error.code == 'email-already-in-use') {
        errorMessage = 'The email address is already in use.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
      } else {
        errorMessage = 'An error occurred. Please try again later.';
      }
      emit(SignUpErrorState(errorMessage));
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
