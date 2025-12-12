part of 'sqf_doctor_cubit.dart';

@immutable
sealed class SqfDoctorState {}

final class SqfDoctorInitialState extends SqfDoctorState {}
final class SqfDoctorLoadingState extends SqfDoctorState {}
final class SqfDoctorLoadedState extends SqfDoctorState {
  final String successMsg;
  SqfDoctorLoadedState({required this.successMsg});
}
final class SqfDoctorErrorState extends SqfDoctorState {
  final String errorMsg;
  SqfDoctorErrorState({required this.errorMsg});
}
final class SqfDoctorDataLoadedState extends SqfDoctorState {
  final List<SqfDoctorListModel> sqfDoctorListModel;
  SqfDoctorDataLoadedState({required this.sqfDoctorListModel});
}

