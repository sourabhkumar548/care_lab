import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../../Model/upload_report_model.dart';

class DocumentRepository {
  final String baseUrl;

  DocumentRepository({
    required this.baseUrl,
  });

  Future<UploadResponse> uploadDocuments(
      List<String> filePaths,
      List<PlatformFile> platformFiles, {
        Function(double)? onProgress,
      }) async {
    try {
      final uri = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', uri);

      // Add files to request
      for (int i = 0; i < platformFiles.length; i++) {
        final platformFile = platformFiles[i];
        final bytes = platformFile.bytes;

        if (bytes != null) {
          final multipartFile = http.MultipartFile.fromBytes(
            'documents[]',
            bytes,
            filename: platformFile.name,
          );
          request.files.add(multipartFile);
        }
      }

      // Send request
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return UploadResponse.fromJson(jsonData);
      } else {
        try {
          final jsonData = json.decode(response.body);
          throw jsonData['message'] ?? 'Upload failed with status: ${response.statusCode}';
        } catch (e) {
          throw 'Upload failed with status: ${response.statusCode}';
        }
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection') ||
          e.toString().contains('Failed host lookup')) {
        throw 'No internet connection or cannot reach server';
      } else if (e.toString().contains('FormatException')) {
        throw 'Invalid response from server';
      } else {
        throw e.toString().replaceAll('Exception: ', '');
      }
    }
  }
}