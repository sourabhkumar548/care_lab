part of 'department_cubit.dart';

@immutable
sealed class DepartmentState {}

final class DepartmentInitialState extends DepartmentState {}
final class DepartmentLoadingState extends DepartmentState {}
final class DepartmentLoadedState extends DepartmentState {
  final DepartmentModel departmentModel;
  DepartmentLoadedState({required this.departmentModel});
}
final class DepartmentErrorState extends DepartmentState {
  final String errorMsg;
  DepartmentErrorState({required this.errorMsg});
}
