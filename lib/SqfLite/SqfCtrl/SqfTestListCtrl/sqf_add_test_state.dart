part of 'sqf_add_test_cubit.dart';

@immutable
sealed class SqfAddTestState {}

final class SqfAddTestInitialState extends SqfAddTestState {}
final class SqfAddTestLoadingState extends SqfAddTestState {}
final class SqfAddTestLoadedState extends SqfAddTestState {
  final String successMsg;
  SqfAddTestLoadedState({required this.successMsg});
}
final class SqfAddTestErrorState extends SqfAddTestState {
  final String errorMsg;
  SqfAddTestErrorState({required this.errorMsg});
}
final class SqfAddTestShowLoadedState extends SqfAddTestState {
  final List<SqfTestListModel> sqfTestListModel;
  SqfAddTestShowLoadedState({required this.sqfTestListModel});
}
