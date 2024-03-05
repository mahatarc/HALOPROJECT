import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      SignInButtonPressedEvent event, Emitter<SignInStates> emit) async {
    try {
      emit(SignInLoadingState());

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: event.email, password: event.password);

      // Check if the user's email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userData.exists) {
            // Retrieve user role
            String role = userData.get('role');

            // Compare user role and navigate to respective dashboard
            if (role == 'seller') {
              emit(SignInNavigateToSellerHomePageActionState());
            } else if (role == 'driver') {
              emit(SignInNavigateToDriverHomePageActionState());
            } else {
              emit(SignInNavigateToBuyerHomePageActionState());
            }
          } else {
            print('User data does not exist.');
            emit(SignInErrorState('user-not-found', 'User not found.'));
          }
        } else {
          print('User is not logged in.');
        }
      } else {
        print('Please verify your email.');
        emit(SignInErrorState('email-not-verified', 'Email not verified.'));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided. Please try again.';
      } else if (e.code == 'email-not-verified') {
        errorMessage = 'Email not verified.';
      } else {
        errorMessage = 'An error occurred. Please try again later.';
      }
      emit(SignInErrorState(e.code, errorMessage));
    }
  }

  FutureOr<void> signUpButtonPressedNavigateEvent(
      SignUpButtonPressedNavigateEvent event, Emitter<SignInStates> emit) {
    emit(SignUpPressedNavigateToSignUpActionState());
  }
  
}
