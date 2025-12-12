part of 'sqf_login_cubit.dart';

@immutable
sealed class SqfLoginState {}

final class SqfLoginInitialState extends SqfLoginState {}
final class SqfLoginLoadingState extends SqfLoginState {}
final class SqfLoginLoadedState extends SqfLoginState {
  final SQFUserModel sqfUserModel;
  SqfLoginLoadedState({required this.sqfUserModel});
}
final class SqfLoginErrorState extends SqfLoginState {
  final String errorMsg;
  SqfLoginErrorState({required this.errorMsg});
}

final class SqfLoginAddLoadedState extends SqfLoginState {
  final String successMsg;
  SqfLoginAddLoadedState({required this.successMsg});
}

final class SqfLoginDataLoadedState extends SqfLoginState {
  final List<SQFUserModel> sqfUserModel;
  SqfLoginDataLoadedState({required this.sqfUserModel});
}
