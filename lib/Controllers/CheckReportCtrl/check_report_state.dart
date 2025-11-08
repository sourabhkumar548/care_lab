part of 'check_report_cubit.dart';

@immutable
sealed class CheckReportState {}

final class CheckReportInitialState extends CheckReportState {}
final class CheckReportLoadingState extends CheckReportState {}
final class CheckReportLoadedState extends CheckReportState {
  final CheckReportPojo checkReportPojo;
  CheckReportLoadedState({required this.checkReportPojo});
}
final class CheckReportErrorState extends CheckReportState {
  final errorMsg;
  CheckReportErrorState({required this.errorMsg});
}
