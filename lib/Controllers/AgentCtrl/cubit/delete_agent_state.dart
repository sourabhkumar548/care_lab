part of 'delete_agent_cubit.dart';

@immutable
sealed class DeleteAgentState {}

final class DeleteAgentInitialState extends DeleteAgentState {}
final class DeleteAgentLoadingState extends DeleteAgentState {}
final class DeleteAgentLoadedState extends DeleteAgentState {
  final String message;
  DeleteAgentLoadedState({required this.message});
}
final class DeleteAgentErrorState extends DeleteAgentState {
  final String errorMsg;
  DeleteAgentErrorState({required this.errorMsg});
}
