part of 'update_case_bloc.dart';

@immutable
sealed class UpdateCaseState {}

final class UpdateCaseInitialState extends UpdateCaseState {}
final class UpdateCaseLoadingState extends UpdateCaseState {}
final class UpdateCaseLoadedState extends UpdateCaseState {
  final String successMsg;
  UpdateCaseLoadedState({required this.successMsg});
}
final class UpdateCaseErrorState extends UpdateCaseState {
  final String errorMsg;
  UpdateCaseErrorState({required this.errorMsg});
}
