part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitialState extends LoginState {}
final class LoginLoadingState extends LoginState {}
final class LoginLoadedState extends LoginState {
  final LoginModel loginModel;
  LoginLoadedState({required this.loginModel});
}
final class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState({required this.error});
}
