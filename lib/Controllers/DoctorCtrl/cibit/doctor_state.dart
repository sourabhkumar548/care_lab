part of 'doctor_cubit.dart';

@immutable
sealed class DoctorState {}

final class DoctorInitialState extends DoctorState {}
final class DoctorLoadingState extends DoctorState {}
final class DoctorLoadedState extends DoctorState {
  final DoctorModel doctorModel;
  DoctorLoadedState({required this.doctorModel});
}
final class DoctorErrorState extends DoctorState {
  final String errorMsg;
  DoctorErrorState({required this.errorMsg});
}
