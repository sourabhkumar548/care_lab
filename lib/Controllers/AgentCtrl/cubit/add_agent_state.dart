part of 'add_agent_cubit.dart';

@immutable
sealed class AddAgentState {}

final class AddAgentInitialState extends AddAgentState {}
final class AddAgentLoadingState extends AddAgentState {}
final class AddAgentLoadedState extends AddAgentState {
  final String successMsg;
  AddAgentLoadedState({required this.successMsg});
}
final class AddAgentErrorState extends AddAgentState {
  final String errorMsg;
  AddAgentErrorState({required this.errorMsg});
}
