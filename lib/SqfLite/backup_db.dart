import 'dart:io';

import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:path/path.dart';

Future<void> backupDatabase() async {
  // 1. Real path to your SQLite DB
  final dbPath = join(
    Directory.current.path,
    '.dart_tool',
    'sqflite_common_ffi',
    'databases',
    'care_lab.db', // <-- put your actual DB filename here
  );

  // 2. Destination path (e.g., Documents folder)
  final backupDir = Directory(
    'C:/Users/${Platform.environment['USERNAME']}/Documents/YourAppBackup',
  );
  final backupPath = join(backupDir.path, 'backup_care_lab.db');

  try {
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final dbFile = File(dbPath);

    if (!await dbFile.exists()) {
      UiHelper.showErrorToste(message: '❌ DB file does not exist');
      return;
    }

    await dbFile.copy(backupPath);
    UiHelper.showSuccessToste(message: '✅ Backup successful: $backupPath');
  } catch (e) {
    UiHelper.showErrorToste(message: '❌ Backup failed');
  }
}


