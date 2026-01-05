part of 'today_collection_cubit.dart';

@immutable
sealed class TodayCollectionState {}

final class TodayCollectionInitialState extends TodayCollectionState {}
final class TodayCollectionLoadingState extends TodayCollectionState {}
final class TodayCollectionLoadedState extends TodayCollectionState {
  final TodayCollectionModel todayCollectionModel;
  TodayCollectionLoadedState({required this.todayCollectionModel});
}
final class TodayCollectionErrorState extends TodayCollectionState {
  final String errorMsg;
  TodayCollectionErrorState({required this.errorMsg});
}
