part of 'sign_up_bloc.dart';

abstract class SignUpEvent {}

class SignUpInitialEvent extends SignUpEvent {}

class SignUpButtonPressedEvent extends SignUpEvent {
  final String email;
  final String password;
  

  SignUpButtonPressedEvent(
      {required this.email,
      required this.password,
      });
}

class LoginButtonPressedEvent extends SignUpEvent {}
