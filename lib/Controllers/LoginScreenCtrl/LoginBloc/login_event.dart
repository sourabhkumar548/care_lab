part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}
class UserLoginEvent extends LoginEvent{
  final String username,password;

  UserLoginEvent({required this.username,required this.password});

}


