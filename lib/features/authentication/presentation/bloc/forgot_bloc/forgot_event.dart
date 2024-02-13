// forgot_event.dart
part of 'forgot_bloc.dart';

abstract class ForgotPasswordEvent {}

class ResetPasswordRequested extends ForgotPasswordEvent {
  final String email;

  ResetPasswordRequested({required this.email});
}

class ForgetPasswordButtonPressedNavigateEvent extends ForgotPasswordEvent {}
