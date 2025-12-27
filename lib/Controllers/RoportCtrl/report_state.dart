part of 'report_cubit.dart';

@immutable
sealed class ReportState {}

final class ReportInitialState extends ReportState {}
final class ReportLoadingState extends ReportState {}
final class ReportLoadedState extends ReportState {
  final   reportModel;
  ReportLoadedState({required this.reportModel});
}
final class ReportErrorState extends ReportState {
  final errorMsg;
  ReportErrorState({required this.errorMsg});
}
