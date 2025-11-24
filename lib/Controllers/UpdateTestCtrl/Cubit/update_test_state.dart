part of 'update_test_cubit.dart';

@immutable
sealed class UpdateTestState {}

final class UpdateTestInitialState extends UpdateTestState {}
final class UpdateTestLoadingState extends UpdateTestState {}
final class UpdateTestLoadedState extends UpdateTestState {
  final UpdateTestModel updateTestModel;
  UpdateTestLoadedState({required this.updateTestModel});
}
final class UpdateTestErrorState extends UpdateTestState {
  final String errorMsg;
  UpdateTestErrorState({required this.errorMsg});
}
