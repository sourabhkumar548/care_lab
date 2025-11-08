part of 'case_number_cubit.dart';

@immutable
sealed class CaseNumberState {}

final class CaseNumberInitialState extends CaseNumberState {}
final class CaseNumberLoadingState extends CaseNumberState {}
final class CaseNumberLoadedState extends CaseNumberState {
  final String CaseNumber;
  CaseNumberLoadedState({required this.CaseNumber});
}
final class CaseNumberErrorState extends CaseNumberState {
  final String errorMsg;
  CaseNumberErrorState({required this.errorMsg});
}
