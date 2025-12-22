import 'package:care_lab_software/Service/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/UploadReportCtrl/document_repository.dart';
import '../Controllers/UploadReportCtrl/upload_report_bloc.dart';
import '../Controllers/UploadReportCtrl/upload_report_event.dart';
import '../Controllers/UploadReportCtrl/upload_report_state.dart';
import '../Helpers/uiHelper.dart';

class ReportUploadScreen extends StatelessWidget {
  const ReportUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentBloc(
        repository: DocumentRepository(
          baseUrl: "https://dzda.in/DocApi/public/api/documents/upload", // Change to your API URL
        ),
      ),
      child: const DocumentUploadView(),
    );
  }
}

class DocumentUploadView extends StatefulWidget {
  const DocumentUploadView({Key? key}) : super(key: key);

  @override
  State<DocumentUploadView> createState() => _DocumentUploadViewState();
}

class _DocumentUploadViewState extends State<DocumentUploadView> {
  List<String> _selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100 ?

      Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            //SIDE BAR
            Container(
              height: 120,
              child: UiHelper.custHorixontalTab(container: "20",context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Upload Patient Report",),

                    const SizedBox(height: 20,),

                    BlocConsumer<DocumentBloc, DocumentState>(
                      listener: (context, state) {
                        if (state is DocumentUploadSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.response.message),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          setState(() => _selectedFiles.clear());
                        } else if (state is DocumentUploadFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else if (state is DocumentsPicked) {
                          setState(() => _selectedFiles = state.filePaths);
                        }
                      },
                      builder: (context, state) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
// Icon
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 100,
                                color: Colors.blue.shade300,
                              ),
                              const SizedBox(height: 24),

// Title
                              const Text(
                                'Upload DOCX Files',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),

// Subtitle
                              Text(
                                'Select one or more DOCX files to upload',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

// Pick Files Button
                              ElevatedButton.icon(
                                onPressed: state is DocumentLoading
                                    ? null
                                    : () {
                                  context
                                      .read<DocumentBloc>()
                                      .add(const PickDocumentsEvent());
                                },
                                icon: const Icon(Icons.folder_open),
                                label: const Text('Select Files'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 24),

// Selected Files Display
                              if (_selectedFiles.isNotEmpty) ...[
                                Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.description, color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${_selectedFiles.length} File(s) Selected',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 24),
                                        ...List.generate(_selectedFiles.length, (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.insert_drive_file,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    _selectedFiles[index],
                                                    style: const TextStyle(fontSize: 14),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

// Upload Button
                                ElevatedButton.icon(
                                  onPressed: state is DocumentLoading
                                      ? null
                                      : () {
                                    context
                                        .read<DocumentBloc>()
                                        .add(UploadDocumentsEvent(_selectedFiles));
                                  },
                                  icon: const Icon(Icons.cloud_upload),
                                  label: const Text('Upload Files'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

// Progress Indicator
                              if (state is DocumentUploading) ...[
                                const SizedBox(height: 16),
                                Card(
                                  color: Colors.blue.shade50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Uploading...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        LinearProgressIndicator(
                                          value: state.progress,
                                          minHeight: 8,
                                          backgroundColor: Colors.grey.shade300,
                                          valueColor: const AlwaysStoppedAnimation<Color>(
                                            Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${(state.progress * 100).toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],

// Success State
                              if (state is DocumentUploadSuccess) ...[
                                const SizedBox(height: 16),
                                Card(
                                  color: Colors.green.shade50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Upload Successful!',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${state.response.totalUploaded} file(s) uploaded',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],

// Loading State
                              if (state is DocumentLoading) ...[
                                const SizedBox(height: 16),
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      )

          :
      Center(
        child: Row(
          children: [
            //SIDE BAR
            Container(
              width: Adaptive.w(15),
              child: UiHelper.custsidebar(container: "20",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Upload Patient Report",),

                    const SizedBox(height: 20,),

                    BlocConsumer<DocumentBloc, DocumentState>(
                      listener: (context, state) {
                        if (state is DocumentUploadSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.response.message),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          setState(() => _selectedFiles.clear());
                        } else if (state is DocumentUploadFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else if (state is DocumentsPicked) {
                          setState(() => _selectedFiles = state.filePaths);
                        }
                      },
                      builder: (context, state) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
// Icon
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 100,
                                color: Colors.blue.shade300,
                              ),
                              const SizedBox(height: 24),

// Title
                              const Text(
                                'Upload DOCX Files',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),

// Subtitle
                              Text(
                                'Select one or more DOCX files to upload',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

// Pick Files Button
                              ElevatedButton.icon(
                                onPressed: state is DocumentLoading
                                    ? null
                                    : () {
                                  context
                                      .read<DocumentBloc>()
                                      .add(const PickDocumentsEvent());
                                },
                                icon: const Icon(Icons.folder_open),
                                label: const Text('Select Files'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 24),

// Selected Files Display
                              if (_selectedFiles.isNotEmpty) ...[
                                Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.description, color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${_selectedFiles.length} File(s) Selected',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 24),
                                        ...List.generate(_selectedFiles.length, (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.insert_drive_file,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    _selectedFiles[index],
                                                    style: const TextStyle(fontSize: 14),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

// Upload Button
                                ElevatedButton.icon(
                                  onPressed: state is DocumentLoading
                                      ? null
                                      : () {
                                    context
                                        .read<DocumentBloc>()
                                        .add(UploadDocumentsEvent(_selectedFiles));
                                  },
                                  icon: const Icon(Icons.cloud_upload),
                                  label: const Text('Upload Files'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

// Progress Indicator
                              if (state is DocumentUploading) ...[
                                const SizedBox(height: 16),
                                Card(
                                  color: Colors.blue.shade50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Uploading...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        LinearProgressIndicator(
                                          value: state.progress,
                                          minHeight: 8,
                                          backgroundColor: Colors.grey.shade300,
                                          valueColor: const AlwaysStoppedAnimation<Color>(
                                            Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${(state.progress * 100).toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],

// Success State
                              if (state is DocumentUploadSuccess) ...[
                                const SizedBox(height: 16),
                                Card(
                                  color: Colors.green.shade50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Upload Successful!',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${state.response.totalUploaded} file(s) uploaded',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],

// Loading State
                              if (state is DocumentLoading) ...[
                                const SizedBox(height: 16),
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

