part of 'doc_bloc.dart';

@immutable
sealed class DocState {}

final class DocInitialState extends DocState {}
final class DocLoadingState extends DocState {}
final class DocLoadedState extends DocState {
  final String fileUrl;
  DocLoadedState({required this.fileUrl});
}
final class DocErrorState extends DocState {
  final String errorMsg;
  DocErrorState({required this.errorMsg});
}
