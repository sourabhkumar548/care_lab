part of 'show_case_cubit.dart';

@immutable
sealed class ShowCaseState {}

final class ShowCaseInitialState extends ShowCaseState {}
final class ShowCaseLoadingState extends ShowCaseState {}
final class ShowCaseLoadedState extends ShowCaseState {
  final Map<String, List<SqfCaseEntryModel>> groupedCases;
  ShowCaseLoadedState({required this.groupedCases});
}
final class ShowCaseErrorState extends ShowCaseState {
  final String errorMsg;
  ShowCaseErrorState({required this.errorMsg});
}
final class ShowCaseLoaded2State extends ShowCaseState {
  final List<SqfCaseEntryModel?> sqfcaseentrymodel;
  ShowCaseLoaded2State({required this.sqfcaseentrymodel});
}

