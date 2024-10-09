// forgot_state.dart

part of 'forgot_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class PasswordResetSent extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String errorMessage;

  ForgotPasswordError({required this.errorMessage});
}

// Define the new state for navigation request
class ForgetPasswordNavigationRequested extends ForgotPasswordState {}
