part of 'between_date_cubit.dart';

@immutable
sealed class BetweenDateState {}

final class BetweenDateInitialState extends BetweenDateState {}
final class BetweenDateLoadingState extends BetweenDateState {}
final class BetweenDateLoadedState extends BetweenDateState {
  final BetweenDateModel betweenDatesModel;
  BetweenDateLoadedState({required this.betweenDatesModel});
}
final class BetweenDateErrorState extends BetweenDateState {
  final String errorMsg;
  BetweenDateErrorState({required this.errorMsg});
}
