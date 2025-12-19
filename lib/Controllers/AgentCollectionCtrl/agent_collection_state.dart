part of 'agent_collection_cubit.dart';

@immutable
sealed class AgentCollectionState {}

final class AgentCollectionInitialState extends AgentCollectionState {}
final class AgentCollectionLoadingState extends AgentCollectionState {}
final class AgentCollectionLoadedState extends AgentCollectionState {
  final SaleModel saleModel;
  AgentCollectionLoadedState({required this.saleModel});
}
final class AgentCollectionErrorState extends AgentCollectionState {
  final String errorMsg;
  AgentCollectionErrorState({required this.errorMsg});
}
