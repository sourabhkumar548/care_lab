part of 'sqf_agent_cubit.dart';

@immutable
sealed class SqfAgentState {}

final class SqfAgentInitialState extends SqfAgentState {}
final class SqfAgentLoadingState extends SqfAgentState {}
final class SqfAgentLoadedState extends SqfAgentState {
  final String successMsg;
  SqfAgentLoadedState({required this.successMsg});
}
final class SqfAgentErrorState extends SqfAgentState {
  final String errorMsg;
  SqfAgentErrorState({required this.errorMsg});
}
final class SqfAgentDataLoadedState extends SqfAgentState {
  final List<SqfAgentListModel> sqfAgentListModel;
  SqfAgentDataLoadedState({required this.sqfAgentListModel});
}
