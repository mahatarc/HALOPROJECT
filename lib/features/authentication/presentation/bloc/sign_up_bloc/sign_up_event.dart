part of 'sign_up_bloc.dart';

abstract class SignUpEvent {}

class SignUpInitialEvent extends SignUpEvent {}

class SignUpButtonPressedEvent extends SignUpEvent {
  final String email;
  final String password;
  final UserModel user;

  SignUpButtonPressedEvent({
    required this.email,
    required this.password,
    required this .user,
  });
}

class LoginButtonPressedEvent extends SignUpEvent {}
