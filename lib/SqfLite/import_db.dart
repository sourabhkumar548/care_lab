import 'dart:io';
import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:path/path.dart';

  Future<void> importDatabase() async {
    // 1. Backup file path (the one created during backup)
    final backupPath = 'C:/Users/${Platform.environment['USERNAME']}/Documents/YourAppBackup/backup_care_lab.db';

    // 2. Destination path where your app expects the live DB
    final dbDir = Directory(
      join(
        Directory.current.path,
        '.dart_tool',
        'sqflite_common_ffi',
        'databases',
      ),
    );
    final dbPath = join(dbDir.path, 'care_lab.db');

    try {
      final backupFile = File(backupPath);

      if (!await backupFile.exists()) {
        UiHelper.showErrorToste(message: '❌ Backup file not found');
        return;
      }

      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }

      // Delete old DB if exists (optional, but recommended)
      final oldDb = File(dbPath);
      if (await oldDb.exists()) {
        await oldDb.delete();
      }

      // Copy backup to app DB folder
      await backupFile.copy(dbPath);

      UiHelper.showSuccessToste(message: '✅ Database imported successfully');
    } catch (e) {
      UiHelper.showErrorToste(message: '❌ Import failed: $e');
      print("$e");
    }
  }


