part of 'expanses_cubit.dart';

@immutable
sealed class ExpansesState {}

final class ExpansesInitialState extends ExpansesState {}
final class ExpansesLoadingState extends ExpansesState {}
final class ExpansesLoadedState extends ExpansesState {
  final successMsg;
  ExpansesLoadedState({required this.successMsg});
}
final class ExpansesErrorState extends ExpansesState {
  final errorMsg;
  ExpansesErrorState({required this.errorMsg});
}
final class ExpansesGetState extends ExpansesState {
  final ExpansesModel expansesModel;
  ExpansesGetState({required this.expansesModel});
}

