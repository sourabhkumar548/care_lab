part of 'delete_rate_list_cubit.dart';

@immutable
sealed class DeleteRateListState {}

final class DeleteRateListInitialState extends DeleteRateListState {}
final class DeleteRateListLoadingState extends DeleteRateListState {}
final class DeleteRateListLoadedState extends DeleteRateListState {
  final String successMsg;
  DeleteRateListLoadedState({required this.successMsg});
}
final class DeleteRateListErrorState extends DeleteRateListState {
  final String errorMsg;
  DeleteRateListErrorState({required this.errorMsg});
}
