part of 'sqf_add_user_cubit.dart';

@immutable
sealed class SqfAddUserState {}

final class SqfAddUserInitialState extends SqfAddUserState {}
final class SqfAddUserLoadingState extends SqfAddUserState {}
final class SqfAddUserLoadedState extends SqfAddUserState {
  final String successMsg;
  SqfAddUserLoadedState({required this.successMsg});
}
final class SqfAddUserErrorState extends SqfAddUserState {
  final String errorMsg;
  SqfAddUserErrorState({required this.errorMsg});
}
