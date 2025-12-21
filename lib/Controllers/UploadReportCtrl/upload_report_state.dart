import 'package:equatable/equatable.dart';
import '../../Model/upload_report_model.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentUploading extends DocumentState {
  final double progress;

  const DocumentUploading({this.progress = 0.0});

  @override
  List<Object?> get props => [progress];
}

class DocumentUploadSuccess extends DocumentState {
  final UploadResponse response;

  const DocumentUploadSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class DocumentUploadFailure extends DocumentState {
  final String error;

  const DocumentUploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class DocumentsPicked extends DocumentState {
  final List<String> filePaths;

  const DocumentsPicked(this.filePaths);

  @override
  List<Object?> get props => [filePaths];
}
