import 'package:care_lab_software/Controllers/UploadReportCtrl/upload_report_event.dart';
import 'package:care_lab_software/Controllers/UploadReportCtrl/upload_report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'document_repository.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository repository;
  List<PlatformFile>? _currentFiles;

  DocumentBloc({required this.repository}) : super(DocumentInitial()) {
    on<PickDocumentsEvent>(_onPickDocuments);
    on<UploadDocumentsEvent>(_onUploadDocuments);
  }

  Future<void> _onPickDocuments(
      PickDocumentsEvent event,
      Emitter<DocumentState> emit,
      ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
        allowMultiple: true,
        withData: true, // This loads file bytes
      );

      if (result != null && result.files.isNotEmpty) {
        _currentFiles = result.files;
        final filePaths = result.files.map((file) => file.name).toList();
        emit(DocumentsPicked(filePaths));
      }
    } catch (e) {
      emit(DocumentUploadFailure('Failed to pick files: $e'));
    }
  }

  Future<void> _onUploadDocuments(
      UploadDocumentsEvent event,
      Emitter<DocumentState> emit,
      ) async {
    if (_currentFiles == null || _currentFiles!.isEmpty) {
      emit(const DocumentUploadFailure('No files selected'));
      return;
    }

    emit(DocumentLoading());

    try {
      final response = await repository.uploadDocuments(
        event.filePaths,
        _currentFiles!,
        onProgress: (progress) {
          emit(DocumentUploading(progress: progress));
        },
      );

      emit(DocumentUploadSuccess(response));
      _currentFiles = null; // Clear after successful upload
    } catch (e) {
      emit(DocumentUploadFailure(e.toString()));
    }
  }
}