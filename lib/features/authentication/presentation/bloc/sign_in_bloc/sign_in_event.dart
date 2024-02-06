part of 'sign_in_bloc.dart';

abstract class SignInEvent {}

class SignInInitialEvent extends SignInEvent {}

class SignInButtonPressedEvent extends SignInEvent {
  final String email;
  final String password;

  SignInButtonPressedEvent({
    required this.email,
    required this.password,
  });
}

class SignUpButtonPressedNavigateEvent extends SignInEvent {}
