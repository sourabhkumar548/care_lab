part of 'payment_history_cubit.dart';

@immutable
sealed class PaymentHistoryState {}

final class PaymentHistoryInitialState extends PaymentHistoryState {}
final class PaymentHistoryLoadingState extends PaymentHistoryState {}
final class PaymentHistoryLoadedState extends PaymentHistoryState {
  final PaymentHistoryModel paymentHistoryModel;
  PaymentHistoryLoadedState({required this.paymentHistoryModel});
}
final class PaymentHistoryErrorState extends PaymentHistoryState {
  final String errorMsg;
  PaymentHistoryErrorState({required this.errorMsg});
}
