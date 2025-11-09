part of 'revenue_cubit.dart';

@immutable
sealed class RevenueState {}

final class RevenueInitialState extends RevenueState {}
final class RevenueLoadingState extends RevenueState {}
final class RevenueLoadedState extends RevenueState {
  final RevenueModel revenueModel;
  RevenueLoadedState({required this.revenueModel});
}
final class RevenueErrorState extends RevenueState {
  final String errorMsg;
  RevenueErrorState({required this.errorMsg});
}
