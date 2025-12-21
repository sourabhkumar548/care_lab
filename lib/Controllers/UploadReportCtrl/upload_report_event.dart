import 'package:equatable/equatable.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class UploadDocumentsEvent extends DocumentEvent {
  final List<String> filePaths;

  const UploadDocumentsEvent(this.filePaths);

  @override
  List<Object?> get props => [filePaths];
}

class PickDocumentsEvent extends DocumentEvent {
  const PickDocumentsEvent();
}
