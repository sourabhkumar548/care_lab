part of 'username_cubit.dart';

@immutable
sealed class UsernameState {}

final class UsernameInitialState extends UsernameState {}
final class UsernameLoadingState extends UsernameState {}
final class UsernameLoadedState extends UsernameState {
  UsernameModel usernameModel;
  UsernameLoadedState({required this.usernameModel});
}
final class UsernameErrorState extends UsernameState {
  String error;
  UsernameErrorState({required this.error});
}
