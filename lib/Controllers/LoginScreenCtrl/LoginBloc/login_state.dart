part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitialState extends LoginState {}
final class LoginLoadingState extends LoginState {}
final class LoginLoadedState extends LoginState {
  String Successmsg;
  LoginLoadedState({required this.Successmsg});
}
final class LoginErrorState extends LoginState {
  String error;
  LoginErrorState({required this.error});
}
