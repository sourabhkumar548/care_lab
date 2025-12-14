part of 'single_case_cubit.dart';

@immutable
sealed class SingleCaseState {}

final class SingleCaseInitialState extends SingleCaseState {}
final class SingleCaseLoadingState extends SingleCaseState {}
final class SingleCaseLoadedState extends SingleCaseState {
  final CaseModel caseModel;
  SingleCaseLoadedState({required this.caseModel});
}
final class SingleCaseErrorState extends SingleCaseState {
  final String errorMsg;
  SingleCaseErrorState({required this.errorMsg});
}
