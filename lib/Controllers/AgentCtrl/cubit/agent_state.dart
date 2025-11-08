part of 'agent_cubit.dart';

@immutable
sealed class AgentState {}

final class AgentInitialState extends AgentState {}
final class AgentLoadingState extends AgentState {}
final class AgentLoadedState extends AgentState {
  final AgentModel agentModel;
  AgentLoadedState({required this.agentModel});
}
final class AgentErrorState extends AgentState {
  final String errorMsg;
  AgentErrorState({required this.errorMsg});
}
