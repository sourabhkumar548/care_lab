part of 'test_data_cubit.dart';

@immutable
sealed class TestDataState {}

final class TestDataInitialState extends TestDataState {}
final class TestDataLoadingState extends TestDataState {}
final class TestDataLoadedState extends TestDataState {
  final String successMsg;
  TestDataLoadedState({required this.successMsg});
}
final class TestDataErrorState extends TestDataState {
  final String errorMsg;
  TestDataErrorState({required this.errorMsg});
}
