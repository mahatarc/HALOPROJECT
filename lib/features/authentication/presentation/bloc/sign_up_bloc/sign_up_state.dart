part of 'sign_up_bloc.dart';

abstract class SignUpState {}

class SignUpActionState extends SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class EmailVerifiedState extends SignUpActionState {}

class LoginPressedNavigateToLoginActionState extends SignUpActionState {}

class EmailVerificationLoadingState extends SignUpActionState {}

class VerificationEmailSentState extends SignUpActionState {
  final String email;

  VerificationEmailSentState(this.email);
}
class StatusTextChangedState extends SignUpState {
  final String text;

  StatusTextChangedState(this.text);
}

class SignUpErrorState extends SignUpState {}
