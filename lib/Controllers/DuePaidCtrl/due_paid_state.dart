part of 'due_paid_cubit.dart';

@immutable
sealed class DuePaidState {}

final class DuePaidInitialState extends DuePaidState {}
final class DuePaidLoadingState extends DuePaidState {}
final class DuePaidLoadedState extends DuePaidState {
  final DueCollectionModel dueCollectionModel;
  DuePaidLoadedState({required this.dueCollectionModel});
}
final class DuePaidErrorState extends DuePaidState {
  final String errorMsg;
  DuePaidErrorState({required this.errorMsg});
}
