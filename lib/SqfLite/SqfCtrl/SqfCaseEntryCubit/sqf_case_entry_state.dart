part of 'sqf_case_entry_cubit.dart';

@immutable
sealed class SqfCaseEntryState {}

final class SqfCaseEntryInitialState extends SqfCaseEntryState {}
final class SqfCaseEntryLoadingState extends SqfCaseEntryState {}
final class SqfCaseEntryLoadedState extends SqfCaseEntryState {
  final String successMsg;
  SqfCaseEntryLoadedState({required this.successMsg});
}
final class SqfCaseEntryErrorState extends SqfCaseEntryState {
  final String errorMsg;
  SqfCaseEntryErrorState({required this.errorMsg});
}
