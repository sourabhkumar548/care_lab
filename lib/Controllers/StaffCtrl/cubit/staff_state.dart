part of 'staff_cubit.dart';

@immutable
sealed class StaffState {}

final class StaffInitialState extends StaffState {}
final class StaffLoadingState extends StaffState {}
final class StaffLoadedState extends StaffState {
  final StaffModel staff;
  StaffLoadedState({required this.staff});
}
final class StaffErrorState extends StaffState {
  final String errorMsg;
  StaffErrorState({required this.errorMsg});
}
