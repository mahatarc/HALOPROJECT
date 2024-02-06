import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      final UserCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
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
