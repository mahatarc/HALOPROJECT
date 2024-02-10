import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      addUserDetails(credential.user!.uid, event.user);

      emit(SignUpNavigateToHomePageActionState());
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

