part of 'rate_list_cubit.dart';

@immutable
sealed class RateListState {}

final class RateListInitialState extends RateListState {}
final class RateListLoadingState extends RateListState {}
final class RateListLoadedState extends RateListState {
  final RateListModel rateListModel;
  RateListLoadedState({required this.rateListModel});
}
final class RateListErrorState extends RateListState {
  final String errorMsg;
  RateListErrorState({required this.errorMsg});
}
