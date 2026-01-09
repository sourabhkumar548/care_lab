part of 'add_doctor_cubit.dart';

@immutable
sealed class AddDoctorState {}

final class AddDoctorInitialState extends AddDoctorState {}
final class AddDoctorLoadingState extends AddDoctorState {}
final class AddDoctorLoadedState extends AddDoctorState {
  final String sussessMsg;
  AddDoctorLoadedState({required this.sussessMsg});
}
final class AddDoctorErrorState extends AddDoctorState {
  final String errorMsg;
  AddDoctorErrorState({required this.errorMsg});
}
