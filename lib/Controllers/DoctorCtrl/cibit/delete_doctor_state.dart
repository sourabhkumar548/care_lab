part of 'delete_doctor_cubit.dart';

@immutable
sealed class DeleteDoctorState {}

final class DeleteDoctorInitialState extends DeleteDoctorState {}
final class DeleteDoctorLoadingState extends DeleteDoctorState {}
final class DeleteDoctorLoadedState extends DeleteDoctorState {
  final String message;
  DeleteDoctorLoadedState({required this.message});
}
final class DeleteDoctorErrorState extends DeleteDoctorState {
  final String errorMsg;
  DeleteDoctorErrorState({required this.errorMsg});
}
