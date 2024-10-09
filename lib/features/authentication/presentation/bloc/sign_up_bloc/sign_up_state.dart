part of 'sign_up_bloc.dart';

abstract class SignUpState {}

class SignUpActionState extends SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

// class EmailVerifiedState extends SignUpActionState {}

class LoginPressedNavigateToLoginActionState extends SignUpActionState {}

class EmailVerificationLoadingState extends SignUpActionState {}

class VerificationEmailSentState extends SignUpActionState {
  final String email;
  final UserModel user;

  VerificationEmailSentState(this.email, this.user);
}

class EmailVerificationInProgressState extends SignUpState {}

class SignUpErrorState extends SignUpState {
  final String errorMessage;

  SignUpErrorState(this.errorMessage);
}


