part of 'case_list_cubit.dart';

@immutable
sealed class CaseListState {}

final class CaseListInitialState extends CaseListState {}
final class CaseListLoadingState extends CaseListState {}
final class CaseListLoadedState extends CaseListState {
  final CaseListModel caseListModel;
  CaseListLoadedState({required this.caseListModel});
}
final class CaseListErrorState extends CaseListState {
  final String errorMsg;
  CaseListErrorState({required this.errorMsg});
}
