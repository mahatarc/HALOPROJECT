import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_states.dart';

class SignInBloc extends Bloc<SignInEvent, SignInStates> {
  SignInBloc() : super(SignInInitialState()) {
    on<SignInInitialEvent>(signInInitialEvent);
    on<SignInButtonPressedEvent>(signInButtonPressedEvent);
    on<SignUpButtonPressedNavigateEvent>(signUpButtonPressedNavigateEvent);
    
  }

  FutureOr<void> signInInitialEvent(
      SignInInitialEvent event, Emitter<SignInStates> emit) {
    emit(SignInInitialState());
  }

  FutureOr<void> signInButtonPressedEvent(
      SignInButtonPressedEvent event, Emitter<SignInStates> emit) async{
         try {
      emit(SignInLoadingState());
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: event.email,
    password: event.password);
      
      emit(SignInNavigateToHomePageActionState());
    } on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
    }
        
      }

  FutureOr<void> signUpButtonPressedNavigateEvent(
      SignUpButtonPressedNavigateEvent event, Emitter<SignInStates> emit) {
        emit(SignUpPressedNavigateToSignUpActionState());
      }
}
