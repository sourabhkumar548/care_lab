import 'package:equatable/equatable.dart';

class DocumentModel extends Equatable {
  final String name;
  final String path;
  final String url;
  final int size;
  final String mimeType;
  final String status;

  const DocumentModel({
    required this.name,
    required this.path,
    required this.url,
    required this.size,
    required this.mimeType,
    required this.status,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      url: json['url'] ?? '',
      size: json['size'] ?? 0,
      mimeType: json['mime_type'] ?? '',
      status: json['status'] ?? '',
    );
  }

  @override
  List<Object?> get props => [name, path, url, size, mimeType, status];
}

class UploadResponse extends Equatable {
  final bool success;
  final String message;
  final List<DocumentModel> uploadedFiles;
  final int totalUploaded;

  const UploadResponse({
    required this.success,
    required this.message,
    required this.uploadedFiles,
    required this.totalUploaded,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final files = (data['uploaded_files'] as List)
        .map((file) => DocumentModel.fromJson(file))
        .toList();

    return UploadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      uploadedFiles: files,
      totalUploaded: data['total_uploaded'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [success, message, uploadedFiles, totalUploaded];
}
