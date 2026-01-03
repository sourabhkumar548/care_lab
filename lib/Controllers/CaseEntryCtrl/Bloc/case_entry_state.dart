part of 'case_entry_bloc.dart';

@immutable
sealed class CaseEntryState {}

final class CaseEntryInitialState extends CaseEntryState {}
final class CaseEntryLoadingState extends CaseEntryState {}
final class CaseEntryLoadedState extends CaseEntryState {
  final String successMessage;
  final String CaseNo;
  final String testFile;
  CaseEntryLoadedState({required this.successMessage,required this.CaseNo,required this.testFile});
}
final class CaseEntryErrorState extends CaseEntryState {
  final String errorMessage;
  CaseEntryErrorState({required this.errorMessage});
}
